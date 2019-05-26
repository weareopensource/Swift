/**
 * Dependencies
 */

import ReactorKit

enum Mode {
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
        case updateTitle(String)
        case done
    }

    // state changes
    enum Mutation {
        case updateTitle(String)
        case dismiss
        case error(NetworkError)
    }

    // the current view state
    struct State {
        var task: Tasks
        var isDismissed: Bool
        var mode: Mode

        init(task: Tasks, mode: Mode) {
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
            self.initialState = State(task: Tasks(id: "", title: ""), mode: mode)
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
                return self.provider.taskService
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
                return self.provider.taskService
                    .save(self.currentState.task)
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
            state.isDismissed = true
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if let code = error.code, code == 401 {
                self.provider.preferencesService.isLogged = false
            }
        }
        return state
    }
}
