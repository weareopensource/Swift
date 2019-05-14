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
        case setUser
        case goSignUp
        case dismiss
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
        case let .updateLogin(login):
            return .just(.updateLogin(login))
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        case .signIn:
            return .concat([
                .just(.setUser),
                .just(.dismiss)
            ])
        case .signUp:
            return .just(.goSignUp)
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .updateLogin(login):
            state.login = login
            return state
        case let .updatePassword(password):
            state.password = password
            return state
        case .setUser:
            print("signIn")
            return state
        case .goSignUp:
            print("signUp")
            return state
        case .dismiss:
            state.isDismissed = true
            return state
        }
    }

}
