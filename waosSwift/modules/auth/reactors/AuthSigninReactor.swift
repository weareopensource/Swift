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
        case updateLogin(String)
        case updatePassword(String)
        case signIn
        case signUp
    }

    // state changes
    enum Mutation {
        case updateLogin(String)
        case updatePassword(String)
        case goSignUp
        case dismiss
        case error(CustomError)
    }

    // the current view state
    struct State {
        var login: String
        var password: String
        var isDismissed: Bool

        init() {
            self.login = ""
            self.password = ""
            self.isDismissed = false
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
        case let .updateLogin(login):
            // log.verbose("♻️ Action -> Mutation : updateLogin(\(self.currentState.login))")
            return .just(.updateLogin(login))
        // update password
        case let .updatePassword(password):
            // log.verbose("♻️ Action -> Mutation : updatePassword(\(self.currentState.password))")
            return .just(.updatePassword(password))
        // signin
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn(\(self.currentState.login), \(self.currentState.password))")
            return self.provider.authService
                .signIn(email: self.currentState.login, password: self.currentState.password)
                .map { result in
                    switch result {
                    case let .success(response):
                        UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                        self.provider.preferencesService.isLogged = true
                        return .dismiss
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
        case let .updateLogin(login):
            state.login = login
        // update password
        case let .updatePassword(password):
            state.password = password
        // go Signup
        case .goSignUp:
            log.verbose("♻️ Mutation -> State : goSignUp")
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error")
            print("YESSSS \(error)")
        }
        return state
    }

}
