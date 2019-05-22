/**
 * Dependencies
 */

import ReactorKit
import Differentiator

/**
 * Reactor
 */

typealias Sections = SectionModel<Void, TasksCellReactor>

final class TasksListReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case refresh([Tasks])
        case get
        case delete(IndexPath)
    }

    // state changes
    enum Mutation {
        case set([Sections])
        case setRefreshing(Bool)
        case succes
        case error(CustomError)
    }

    // the current view state
    struct State {
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
                    case .success: return .succes
                    case let .error(err): return .error(err)
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
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error")
            print("YESSSS \(error)")
        // success
        case .succes:
            log.verbose("♻️ Mutation -> State : succes")
        }
        return state
    }

    // reactor init

    func viewReactor(_ taskCellReactor: TasksCellReactor) -> TasksViewReactor {
        let task = taskCellReactor.currentState
        return TasksViewReactor(provider: self.provider, mode: .view(task))
    }

    func addReactor() -> TasksViewReactor {
        return TasksViewReactor(provider: self.provider, mode: .add)
    }

    func editReactor(_ taskCellReactor: TasksCellReactor) -> TasksViewReactor {
        let task = taskCellReactor.currentState
        return TasksViewReactor(provider: self.provider, mode: .edit(task))
    }
}
