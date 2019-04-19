import ReactorKit

final class TasksListReactor: Reactor {

    // represent user actions
    enum Action {
        case get
        case create
    }

    // represent state changes
    enum Mutation {
        case createTask
        case getTasks([Task])
        case setLoading(Bool)
    }

    // represents the current view state
    struct State {
        var isLoading: Bool
        var tasks: [Task]

        init() {
            self.isLoading = false
            self.tasks = []
        }
    }

    let taskService = TaskService()
    let initialState: State

    init() {
        self.initialState = State()
    }

    // Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)
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

    // Mutation -> State (reduce() generates a new State from a previous State and a Mutation)
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
