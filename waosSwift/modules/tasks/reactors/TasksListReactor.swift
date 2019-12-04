/**
 * Dependencies
 */

import ReactorKit
import Differentiator

/**
 * Reactor
 */

typealias TasksSections = SectionModel<Void, TasksCellReactor>

final class TasksListReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // task
        case refresh([Tasks])
        case get
        case delete(IndexPath)
        // user
        case checkUserToken // (only in tab main controller)
    }

    // state changes
    enum Mutation {
        // task
        case set([Tasks])
        case setRefreshing(Bool)
        // default
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        // Tasks
        var tasks: [Tasks]
        var sections: [TasksSections]
        var isRefreshing: Bool
        var error: DiplayError?

        init() {
            self.tasks = []
            self.sections = [TasksSections(model: Void(), items: [])]
            self.isRefreshing = false
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let initialState: State

    // MARK: Initialization

    init(provider: AppServicesProviderType) {
        self.provider = provider
        self.initialState = State()
    }

    // MARK: Transform -> Merges two observables into a single observabe : 1. Action observable from Reactor 2. Action observable from global state

    func transform(action: Observable<Action>) -> Observable<Action> {
        let refresh = self.provider.tasksService.tasks
            .map { Action.refresh($0 ?? []) }
        return Observable.of(action, refresh).merge()
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // refresh
        case let .refresh(tasks):
            log.verbose("♻️ Action -> Mutation : refresh")
            return .just(.set(tasks))
        // get
        case .get:
            log.verbose("♻️ Action -> Mutation : get")
            return Observable.concat([
                .just(.setRefreshing(true)),
                self.provider.tasksService
                    .list()
                    .map { result in
                        switch result {
                        case let .success(result): return .set(result.data)
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        // delete
        case let .delete(i):
            log.verbose("♻️ Action -> Mutation : delete")
            let task = self.currentState.sections[i].currentState
            return self.provider.tasksService
                .delete(task)
                .map { result in
                    switch result {
                    case .success: return .success("delete")
                    case let .error(err): return .error(err)
                    }
            }
        // check user token when open application
        case .checkUserToken:
            log.verbose("♻️ Action -> Mutation : checkUserToken")
            let status = getTokenStatus()
            switch status {
            case .isOk:
                return .just(.success("token ok"))
            case .toDefine:
                self.provider.preferencesService.isLogged = false
                return .just(.success("token to define"))
            case .toRenew:
                return self.provider.authService
                    .token()
                    .map { result in
                        switch result {
                        case let .success(response):
                            UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                            return .success("token renewed")
                        case let .error(err):
                            self.provider.preferencesService.isLogged = false
                            return .error(err)
                        }
                }
            }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // refreshing
        case let .setRefreshing(isRefreshing):
            log.verbose("♻️ Mutation -> State : setRefreshing")
            state.isRefreshing = isRefreshing
        // set
        case let .set(tasks):
            log.verbose("♻️ Mutation -> State : set")
            let difference = tasks.difference(from: state.tasks)
            state.tasks = state.tasks.applying(difference) ?? []
            for change in difference {
                switch change {
                case let .remove(index, _, _):
                    state.sections.remove(at: IndexPath(item: index, section: 0))
                case let .insert(index, element, _):
                    state.sections.insert(TasksCellReactor(task: element), at: IndexPath(item: index, section: 0))
                }
            }
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            } else {
                state.error = DiplayError(title: error.message, description: (error.description ?? "Unknown error"))
            }
        }
        return state
    }

    // reactor init

    func addReactor() -> TasksViewReactor {
        return TasksViewReactor(provider: self.provider, mode: .add)
    }

    func editReactor(_ taskCellReactor: TasksCellReactor) -> TasksViewReactor {
        let task = taskCellReactor.currentState
        return TasksViewReactor(provider: self.provider, mode: .edit(task))
    }
}
