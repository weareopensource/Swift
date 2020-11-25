/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class AuthSigninReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // inputs
        case updateEmail(String)
        case validateEmail
        case updatePassword(String)
        case updateIsFilled(Bool)
        // others
        case signIn
        case oAuthApple(String, String, String, String)
        case signUp
    }

    // state changes
    enum Mutation {
        // inputs
        case updateEmail(String)
        case updatePassword(String)
        case updateIsFilled(Bool)
        // others
        case goSignUp
        // default
        case setRefreshing(Bool)
        case validationError(CustomError)
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var isFilled: Bool
        var isRefreshing: Bool
        var errors: [DisplayError]
        var error: DisplayError?

        init() {
            self.user = User()
            self.isFilled = false
            self.isRefreshing = false
            self.errors = []
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
        // password 
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        // form
        case let .updateIsFilled(isFilled):
            return .just(.updateIsFilled(isFilled))
        // signin
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn(\(self.currentState.user.email))")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.authService
                    .signIn(email: self.currentState.user.email, password: self.currentState.user.password ?? "")
                    .map { result in
                        switch result {
                        case let .success(response):
                            UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                            UserDefaults.standard.set(response.user.terms ?? nil, forKey: "Terms")
                            self.provider.preferencesService.isLogged = true
                            return .success("signIn")
                        case let .error(err):
                            return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        // signin
        case let .oAuthApple(firstName, lastName, email, sub):
            log.verbose("♻️ Action -> Mutation : oAuthApple")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.authService
                    .oauth(strategy: false, key: "sub", value: sub, firstName: firstName, lastName: lastName, email: email)
                    .map { result in
                        switch result {
                        case let .success(response):
                            UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                            UserDefaults.standard.set(response.user.terms ?? nil, forKey: "Terms")
                            self.provider.preferencesService.isLogged = true
                            return .success("oAuth")
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        // signup
        case .signUp:
            log.verbose("♻️ Action -> Mutation : signUp")
            return .just(.goSignUp)
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // update login
        case let .updateEmail(email):
            state.user.email = email
        // update password
        case let .updatePassword(password):
            state.user.password = password
        // form
        case let .updateIsFilled(isFilled):
            state.isFilled = isFilled
        // go Signup
        case .goSignUp:
            log.verbose("♻️ Mutation -> State : goSignUp")
            state.error = nil
        // refreshing
        case let .setRefreshing(isRefreshing):
            log.verbose("♻️ Mutation -> State : setRefreshing")
            state.error = nil
            state.isRefreshing = isRefreshing
        // success
        case let .success(success):
            state.error = nil
            log.verbose("♻️ Mutation -> State : succes \(success)")
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

    func signUpReactor() -> AuthSignUpReactor {
        return AuthSignUpReactor(provider: self.provider)
    }

    func forgotReactor() -> AuthForgotReactor {
        return AuthForgotReactor(provider: self.provider)
    }

}
