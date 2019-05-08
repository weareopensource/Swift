/**
 * Dependencies
 */

import ReactorKit

enum Mode {
    case add
    case view(Task)
    case edit(Task)
}

/**
 * Reactor
 */

final class TaskReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case updateTitle(String)
        case done
    }

    // state changes
    enum Mutation {
        case updateTitle(String)
        case dismiss
    }

    // the current view state
    struct State {
        var task: Task
        var isDismissed: Bool
        var mode: Mode

        init(task: Task, mode: Mode) {
            self.task = task
            self.isDismissed = false
            self.mode = mode
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let mode: Mode
    let initialState: State

    // MARK: Initialization

    init(provider: AppServicesProviderType, mode: Mode) {
        self.provider = provider
        self.mode = mode

        switch mode {
        case .add:
            self.initialState = State(task: Task(id: "", title: ""), mode: mode)
        case .view(let task):
            self.initialState = State(task: task, mode: mode)
        case .edit(let task):
            print(task)
            self.initialState = State(task: task, mode: mode)
            print("test 0 \(self.currentState)")
        }
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // updateTitle
        case let .updateTitle(title):
            return .just(.updateTitle(title))
        // done
        case .done:
            print("done \(mode) => \(self.currentState.task)")
            switch mode {
            case .add:
                return self.provider.taskService
                    .create(title: self.currentState.task.title)
                    .map { _ in .dismiss }
            case .view:
                return Observable.just(Mutation.dismiss)
            case .edit:
                return self.provider.taskService
                    .save(task: self.currentState.task)
                    .map { _ in .dismiss }
            }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateTitle(title):
            state.task.title = title
            return state
        case .dismiss:
            state.isDismissed = true
            return state
        }
    }
}
