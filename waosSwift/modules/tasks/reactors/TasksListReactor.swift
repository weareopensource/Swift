/**
 * Dependencies
 */

import ReactorKit
import Differentiator

/**
 * Reactor
 */

typealias Sections = SectionModel<Void, TaskCellReactor>

final class TasksListReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case refresh([Task])
        case get
        case delete(IndexPath)
    }

    // state changes
    enum Mutation {
        case set([Sections])
    }

    // the current view state
    struct State {
        var tasks: [Sections]

        init() {
            self.tasks = [Sections(model: Void(), items: [])]
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
            print("Action -> Mutation refresh")
            let items = tasks.map(TaskCellReactor.init)
            let section = Sections(model: Void(), items: items)
            return .just(.set([section]))
        // get
        case .get:
            print("Action -> Mutation get")
            return self.provider.taskService
                .get()
                .map { tasks in
                    let items = tasks.map(TaskCellReactor.init)
                    let section = Sections(model: Void(), items: items)
                    return .set([section])
                }
        // delete
        case let .delete(i):
            print("Action -> Mutation delete")
            let task = self.currentState.tasks[i].currentState
            return self.provider.taskService
                .delete(task: task)
                .flatMap { _ in Observable.empty() }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // set
        case let .set(tasks):
            print("Mutation -> State set")
            state.tasks = tasks
            return state
        }
    }

    // reactor init

    func viewReactor(_ taskCellReactor: TaskCellReactor) -> TaskReactor {
        let task = taskCellReactor.currentState
        return TaskReactor(provider: self.provider, mode: .view(task))
    }

    func addReactor() -> TaskReactor {
        return TaskReactor(provider: self.provider, mode: .add)
    }

    func editReactor(_ taskCellReactor: TaskCellReactor) -> TaskReactor {
        let task = taskCellReactor.currentState
        return TaskReactor(provider: self.provider, mode: .edit(task))
    }
}
