/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class TasksListReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case get
        case create
    }

    // state changes
    enum Mutation {
        case createTask
        case getTasks([Task])
        case setLoading(Bool)
    }

    // the current view state
    struct State {
        var isLoading: Bool
        var tasks: [Task]

        init() {
            self.isLoading = false
            self.tasks = []
        }
    }

    // MARK: Properties

    let taskService = TaskService()
    let initialState = State()

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // get
        case .get:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.taskService.get()
                    .map { Mutation.getTasks($0) },
                Observable.just(Mutation.setLoading(false))
                ])
        // create
        case .create:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.createTask).delay(0.1, scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
                ])
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // get
        case let .getTasks(tasks):
            var newState = state
            newState.tasks = tasks
            return newState
        // create
        case .createTask:
            print("create Task")
        // loading
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        }
        return state
    }

}
