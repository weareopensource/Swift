/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class AuthSignUpReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case updateFirstName(String)
        case updateLastName(String)
        case updateEmail(String)
        case updatePassword(String)
        case signIn
        case signUp
    }

    // state changes
    enum Mutation {
        case updateFirstName(String)
        case updateLastName(String)
        case updateEmail(String)
        case updatePassword(String)
        case goSignIn
        case dismiss
        case error(NetworkError)
    }

    // the current view state
    struct State {
        var firstName: String
        var lastName: String
        var email: String
        var password: String
        var isDismissed: Bool

        init() {
            self.firstName = ""
            self.lastName = ""
            self.email = ""
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
        // update firstName
        case let .updateFirstName(firstName):
            return .just(.updateFirstName(firstName))
            // update password
        // update Password
        case let .updateLastName(lastName):
            return .just(.updateLastName(lastName))
        // update login
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        // update password
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        // signin
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn")
            return .just(.goSignIn)
        // signup
        case .signUp:
            log.verbose("♻️ Action -> Mutation : signUp(\(self.currentState.firstName), \(self.currentState.lastName), \(self.currentState.email), \(self.currentState.password))")
            return self.provider.authService
                .signUp(firstName: self.currentState.firstName, lastName: self.currentState.lastName, email: self.currentState.email, password: self.currentState.password)
                .map { result in
                    switch result {
                    case let .success(response):
                        UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                        self.provider.preferencesService.isLogged = true
                        return .dismiss
                    case let .error(err): return .error(err)
                    }
            }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // update firstname
        case let .updateFirstName(firstName):
            state.firstName = firstName
        // update lastname
        case let .updateLastName(lastName):
            state.lastName = lastName
        // update email
        case let .updateEmail(email):
            state.email = email
        // update password
        case let .updatePassword(password):
            state.password = password
        // go Signup
        case .goSignIn:
            state.isDismissed = true
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            }
        }
        return state
    }

}
