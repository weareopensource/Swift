/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class UserPreferenceReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // inputs
        case updateBackground(Bool)
        // work
        case done
    }

    // state changes
    enum Mutation {
        // inputs
        case updateBackground(Bool)
        // work
        case dismiss
        // default
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var policy: UsersPolicy
        var background: Bool
        // work
        var isDismissed: Bool
        // default
        var errors: [DisplayError]
        var error: DisplayError?

        init(background: Bool, user: User, policy: UsersPolicy) {
            self.user = user
            self.policy = policy
            self.background = background
            // work
            self.isDismissed = false
            // default
            self.errors = []
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let initialState: State

    // MARK: Initialization

    init(provider: AppServicesProviderType, user: User, policy: UsersPolicy) {
        self.provider = provider
        self.initialState = State(background: self.provider.preferencesService.isBackground, user: user, policy: policy)
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // inputs
        case let .updateBackground(background):
            self.provider.preferencesService.isBackground = background
            return .just(.updateBackground(background))
        // done
        case .done:
            return self.provider.userService
                .update(self.currentState.user)
                .map { result in
                    switch result {
                    case .success: return .dismiss
                    case let .error(err): return .error(err)
                    }
                }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // inputs
        case let .updateBackground(background):
            state.background = background
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
            state.errors = []
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.error = nil
            state.errors = purgeErrors(errors: state.errors, specificTitles: [success])
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            let _error: DisplayError = getDisplayError(error, self.provider.preferencesService.isLogged)
            self.provider.preferencesService.isLogged = _error.code == 401 ? false : true
            state.error = _error
        }
        return state
    }

}
