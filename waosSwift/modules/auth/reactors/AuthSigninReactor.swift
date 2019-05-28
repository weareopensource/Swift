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
        case updateEmail(String)
        case updatePassword(String)
        case signIn
        case signUp
    }

    // state changes
    enum Mutation {
        case updateEmail(String)
        case updatePassword(String)
        case goSignUp
        case success(String)
        case error(NetworkError)
    }

    // the current view state
    struct State {
        var email: String
        var password: String
        var error: DiplayError

        init() {
            self.email = ""
            self.password = ""
            self.error = DiplayError(title: "", description: "")
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
        // update login
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        // update password
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        // signin
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn(\(self.currentState.email), \(self.currentState.password))")
            return self.provider.authService
                .signIn(email: self.currentState.email, password: self.currentState.password)
                .map { result in
                    switch result {
                    case let .success(response):
                        UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                        self.provider.preferencesService.isLogged = true
                        return .success("signIn")
                    case let .error(err): return .error(err)
                    }
                }
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
            state.email = email
        // update password
        case let .updatePassword(password):
            state.password = password
        // go Signup
        case .goSignUp:
            log.verbose("♻️ Mutation -> State : goSignUp")
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                state.error = DiplayError(title: "Unauthorized", description: "Oups, wrong email or password.")
            } else {
                let description = error.description ?? "Unknown error"
                state.error = DiplayError(title: error.message, description: description.replacingOccurrences(of: ".", with: ".\n"))
            }
        }
        return state
    }

    // reactor init

    func signUpReactor() -> AuthSignUpReactor {
        return AuthSignUpReactor(provider: self.provider)
    }

}
