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
        case validatePassword
        case updateIsFilled(Bool)
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
        case updateIsFilled(Bool)
        // others
        case goSignIn
        // default
        case dismiss
        case setRefreshing(Bool)
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var isDismissed: Bool
        var isRefreshing: Bool
        var isFilled: Bool
        var errors: [DisplayError]

        init() {
            self.user = User()
            self.isDismissed = false
            self.isRefreshing = false
            self.isFilled = false
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
        // firstName
        case let .updateFirstName(firstName):
            return .just(.updateFirstName(firstName))
        case .validateFirstName:
            switch currentState.user.validate(.firstname) {
            case .valid: return .just(.success("\(User.Validators.firstname)"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
            // update password
        // lastname
        case let .updateLastName(lastName):
            return .just(.updateLastName(lastName))
        case .validateLastName:
            switch currentState.user.validate(.lastname) {
            case .valid: return .just(.success("\(User.Validators.lastname)"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
        // email
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case .validateEmail:
            switch currentState.user.validate(.email) {
            case .valid: return .just(.success("\(User.Validators.email)"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
        // password
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        case .validatePassword:
            switch currentState.user.validate(.password) {
            case .valid: return .just(.success("\(User.Validators.password)"))
            case let .invalid(err): return .just(.error(err[0] as! CustomError))
            }
        // form
        case let .updateIsFilled(isFilled):
            return .just(.updateIsFilled(isFilled))
        // signin
        case .signIn:
            log.verbose("♻️ Action -> Mutation : signIn")
            return .just(.goSignIn)
        // signup
        case .signUp:
            log.verbose("♻️ Action -> Mutation : signUp(\(self.currentState.user.firstName), \(self.currentState.user.lastName), \(self.currentState.user.email))")
            return .concat([
                .just(.setRefreshing(true)),
                self.provider.authService
                    .signUp(firstName: self.currentState.user.firstName, lastName: self.currentState.user.lastName, email: self.currentState.user.email, password: self.currentState.user.password ?? "")
                    .map { result in
                        switch result {
                        case let .success(response):
                            UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                            self.provider.preferencesService.isLogged = true
                            return .dismiss
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
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
            state.user.password = password
        // form
        case let .updateIsFilled(isFilled):
            state.isFilled = isFilled
        // go Signup
        case .goSignIn:
            log.verbose("♻️ Mutation -> State : goSignIn")
            state.isDismissed = true
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
        // refreshing
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.errors = purgeErrors(errors: state.errors, titles: [success, "Schema validation error", "jwt", "unknow"])
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
            } else {
                if state.errors.firstIndex(where: { $0.title == error.message }) == nil {
                    state.errors.insert(DisplayError(title: error.message, description: (error.description ?? "Unknown error")), at: 0)
                }
            }
        }
        return state
    }

}
