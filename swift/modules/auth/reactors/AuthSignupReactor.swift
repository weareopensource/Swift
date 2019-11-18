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
        // inputs
        case updateFirstName(String)
        case validateFirstName
        case updateLastName(String)
        case validateLastName
        case updateEmail(String)
        case validateEmail
        case updatePassword(String)
        // others
        case signIn
        case signUp
    }

    // state changes
    enum Mutation {
        // inputs
        case updateFirstName(String)
        case updateLastName(String)
        case updateEmail(String)
        case updatePassword(String)
        // others
        case goSignIn
        case dismiss
        // default
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var password: String
        var isDismissed: Bool
        var error: DiplayError?

        init() {
            self.user = User(id: nil, firstName: "", lastName: "", email: "", roles: nil)
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
        // firstName
        case let .updateFirstName(firstName):
            return .just(.updateFirstName(firstName))
        case .validateFirstName:
            switch currentState.user.validate(.firstname) {
            case .valid: return .just(.success("firstname"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
            // update password
        // lastname
        case let .updateLastName(lastName):
            return .just(.updateLastName(lastName))
        case .validateLastName:
            switch currentState.user.validate(.lastname) {
            case .valid: return .just(.success("lastname"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
        // email
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case .validateEmail:
            switch currentState.user.validate(.email) {
            case .valid: return .just(.success("mail"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
        // password
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        // signin
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn")
            return .just(.goSignIn)
        // signup
        case .signUp:
            log.verbose("♻️ Action -> Mutation : signUp(\(self.currentState.user.firstName), \(self.currentState.user.lastName), \(self.currentState.user.email))")
            return self.provider.authService
                .signUp(firstName: self.currentState.user.firstName, lastName: self.currentState.user.lastName, email: self.currentState.user.email, password: self.currentState.password)
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
            state.user.firstName = firstName
        // update lastname
        case let .updateLastName(lastName):
            state.user.lastName = lastName
        // update email
        case let .updateEmail(email):
            state.user.email = email
        // update password
        case let .updatePassword(password):
            state.password = password
        // go Signup
        case .goSignIn:
            log.verbose("♻️ Mutation -> State : goSignIn")
            state.isDismissed = true
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.error = nil
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            } else {
                state.error = DiplayError(title: error.message, description: (error.description ?? "Unknown error"))
            }
        }
        return state
    }

}
