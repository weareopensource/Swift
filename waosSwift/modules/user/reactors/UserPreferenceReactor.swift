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
        // default
        case done
    }

    // state changes
    enum Mutation {
        // inputs
        case updateBackground(Bool)
        case dismiss
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var background: Bool
        var isDismissed: Bool
        var errors: [DisplayError]
        var error: DisplayError?

        init(background: Bool) {
            self.background = background
            self.isDismissed = false
            self.errors = []
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let initialState: State

    // MARK: Initialization

    init(provider: AppServicesProviderType) {
        self.provider = provider
        self.initialState = State(background: self.provider.preferencesService.isBackground)
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
            return .just(.dismiss)
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
            let _error: DisplayError = getDisplayError(error)
            self.provider.preferencesService.isLogged = _error.code == 401 ? false : true
            state.error = _error
        }
        return state
    }

}
