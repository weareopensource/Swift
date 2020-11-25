/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class AuthForgotReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // inputs
        case updateEmail(String)
        case validateEmail
        case updateIsFilled(Bool)
        // others
        case reset
        case signIn
    }

    // state changes
    enum Mutation {
        // inputs
        case updateEmail(String)
        case updateIsFilled(Bool)
        // others
        case goSignIn
        // default
        case setRefreshing(Bool)
        case validationError(CustomError)
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var isDismissed: Bool
        var isFilled: Bool
        var isRefreshing: Bool
        var errors: [DisplayError]
        var error: DisplayError?
        var success: String

        init() {
            self.user = User()
            self.isDismissed = false
            self.isFilled = false
            self.isRefreshing = false
            self.errors = []
            self.success = ""
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

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // email
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case .validateEmail:
            switch currentState.user.validate(.email) {
            case .valid: return .just(.success("\(User.Validators.email)"))
            case let .invalid(err): return .just(.validationError(err[0] as! CustomError))
            }
        // form
        case let .updateIsFilled(isFilled):
            return .just(.updateIsFilled(isFilled))
        // reset
        case .reset:
            log.verbose("♻️ Action -> Mutation : forgot (\(self.currentState.user.email))")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.authService
                    .forgot(email: self.currentState.user.email)
                    .map { result in
                        switch result {
                        case let .success(response):
                            return .success(response.message)
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        // signup
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn")
            return .just(.goSignIn)
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // update login
        case let .updateEmail(email):
            state.user.email = email
        // form
        case let .updateIsFilled(isFilled):
            state.isFilled = isFilled
        // go Signin
        case .goSignIn:
            log.verbose("♻️ Mutation -> State : goSignIn")
            state.error = nil
            state.isDismissed = true
        // refreshing
        case let .setRefreshing(isRefreshing):
            log.verbose("♻️ Mutation -> State : setRefreshing")
            state.error = nil
            state.isRefreshing = isRefreshing
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.error = nil
            state.success = success
            state.errors = purgeErrors(errors: state.errors, specificTitles: [success])
        // error
        case let .validationError(error):
            log.verbose("♻️ Mutation -> State : validation error \(error)")
            if state.errors.firstIndex(where: { $0.title == error.message }) == nil {
                state.errors.insert(getDisplayError(error, self.provider.preferencesService.isLogged), at: 0)
            }
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            let _error: DisplayError = getDisplayError(error, self.provider.preferencesService.isLogged)
            state.error = _error
        }
        return state
    }

    // reactor init

    func signInReactor() -> AuthSignUpReactor {
        return AuthSignUpReactor(provider: self.provider)
    }

}
