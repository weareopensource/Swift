/**
 * Dependencies
 */

import ReactorKit
import Differentiator
import Toaster

/**
 * Reactor
 */

typealias Sections = SectionModel<Void, TasksCellReactor>

final class TasksListReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // Tasks
        case refresh([Tasks])
        case get
        case delete(IndexPath)
        // User check (only in tab main controller)
        case logout
        case checkUserToken
    }

    // state changes
    enum Mutation {
        // Tasks
        case set([Sections])
        case setRefreshing(Bool)
        // default
        case success(String)
        case error(NetworkError)
    }

    // the current view state
    struct State {
        // Tasks
        var isRefreshing: Bool
        var tasks: [Sections]

        init() {
            self.tasks = [Sections(model: Void(), items: [])]
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
        let refresh = self.provider.taskService.tasks
            .map { Action.refresh($0 ?? [   ]) }
        return Observable.of(action, refresh).merge()
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // refresh
        case let .refresh(tasks):
            log.verbose("♻️ Action -> Mutation : refresh")
            let items = tasks.map(TasksCellReactor.init)
            let section = Sections(model: Void(), items: items)
            return .just(.set([section]))
        // get
        case .get:
            log.verbose("♻️ Action -> Mutation : get")
            return Observable.concat([
                .just(.setRefreshing(true)),
                self.provider.taskService
                    .list()
                    .map { result in
                        switch result {
                        case let .success(test): return .set([Sections(model: Void(), items: test.data.map(TasksCellReactor.init))])
                        case let .error(err): return .error(err)
                        }
                    },
                .just(.setRefreshing(false))
            ])
        // delete
        case let .delete(i):
            log.verbose("♻️ Action -> Mutation : delete")
            let task = self.currentState.tasks[i].currentState
            return self.provider.taskService
                .delete(task)
                .map { result in
                    switch result {
                    case .success: return .success("delete")
                    case let .error(err): return .error(err)
                    }
                }
        // case logout
        case .logout:
            self.provider.preferencesService.isLogged = false
            return .just(.success("logout"))
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
        // set
        case let .set(tasks):
            log.verbose("♻️ Mutation -> State : set")
            state.tasks = tasks
        // refreshing
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            } else {
                Toast(text: (error.description ?? "Unknown error").replacingOccurrences(of: ".", with: ".\n"), delay: 0, duration: Delay.long).show()
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
