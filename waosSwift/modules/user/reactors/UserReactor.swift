/**
 * Dependencies
 */

import ReactorKit
/**
 * Reactor
 */

final class UserReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // user
        case refresh(User)
        case get
        case logout
    }

    // state changes
    enum Mutation {
        // user
        case set(User)
        case setRefreshing(Bool)
        // default
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var isRefreshing: Bool
        var error: DiplayError?

        init() {
            self.user = User(id: nil, firstName: "", lastName: "", email: "", roles: nil)
            self.isRefreshing = false
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

    // MARK: Transform -> Merges two observables into a single observabe : 1. Action observable from Reactor 2. Action observable from global state

    func transform(action: Observable<Action>) -> Observable<Action> {
        let refresh = self.provider.userService.user
            .map { Action.refresh($0 ?? User(id: nil, firstName: "", lastName: "", email: "", roles: nil)) }
        return Observable.of(action, refresh).merge()
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        // refresh
        case let .refresh(user):
            log.verbose("♻️ Action -> Mutation : refresh")
            return .just(.set(user))
        // get
        case .get:
            log.verbose("♻️ Action -> Mutation : get")
            return Observable.concat([
                .just(.setRefreshing(true)),
                self.provider.userService
                    .me()
                    .map { result in
                        switch result {
                        case let .success(result): return .set(result.data)
                        case let .error(err): return .error(err)
                        }
                },
                .just(.setRefreshing(false))
            ])
        // case logout
        case .logout:
            self.provider.preferencesService.isLogged = false
            return .just(.success("logout"))
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // refreshing
        case let .setRefreshing(isRefreshing):
            log.verbose("♻️ Mutation -> State : setRefreshing")
            state.isRefreshing = isRefreshing
        // set
        case let .set(user):
            log.verbose("♻️ Mutation -> State : set", user)
            state.user = user
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            // state.error = nil
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

    // reactor init

    func editReactor(_ user: User) -> UserViewReactor {
        return UserViewReactor(provider: self.provider, mode: .edit(user))
    }
}