/**
 * Dependencies
 */

import ReactorKit

enum TasksViewMode {
    case add
    case view(Tasks)
    case edit(Tasks)
}

/**
 * Reactor
 */

final class TasksViewReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // inputs
        case updateTitle(String)
        // default
        case done
    }

    // state changes
    enum Mutation {
        // inputs
        case updateTitle(String)
        // default
        case dismiss
        case error(CustomError)
    }

    // the current view state
    struct State {
        var task: Tasks
        var mode: TasksViewMode
        var isDismissed: Bool
        var error: DisplayError?

        init(task: Tasks, mode: TasksViewMode) {
            self.task = task
            self.mode = mode
            self.isDismissed = false
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let mode: TasksViewMode
    let initialState: State

    // MARK: Initialization

    init(provider: AppServicesProviderType, mode: TasksViewMode) {
        self.provider = provider
        self.mode = mode

        switch mode {
        case .add:
            self.initialState = State(task: Tasks(), mode: mode)
        case .view(let task):
            self.initialState = State(task: task, mode: mode)
        case .edit(let task):
            self.initialState = State(task: task, mode: mode)
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
            switch mode {
            case .add:
                return self.provider.tasksService
                    .create(self.currentState.task)
                    .map { result in
                        switch result {
                        case .success: return .dismiss
                        case let .error(err): return .error(err)
                        }
                    }
            case .view:
                return .just(.dismiss)
            case .edit:
                return self.provider.tasksService
                    .update(self.currentState.task)
                    .map { result in
                        switch result {
                        case .success: return .dismiss
                        case let .error(err): return .error(err)
                        }
                    }
            }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // update title
        case let .updateTitle(title):
            state.task.title = title
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
            state.error = nil
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            } else {
                state.error = DisplayError(title: error.message, description: (error.description ?? "Unknown error"))
            }
        }
        return state
    }
}
