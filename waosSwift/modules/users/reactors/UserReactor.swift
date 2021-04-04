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
        case delete
        case data
    }

    // state changes
    enum Mutation {
        // user
        case set(User)
        case setPolicy(UsersPolicy?)
        // work
        case setRefreshing(Bool)
        // default
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var user: User
        var policy: UsersPolicy
        var isRefreshing: Bool
        var error: DisplayError?
        var configuration = config

        init() {
            self.user = User()
            self.policy = UsersPolicy()
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
            .filterNil()
            .distinctUntilChanged()
            .map { Action.refresh($0) }
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
            guard !self.currentState.isRefreshing else { return .empty() }
            log.verbose("♻️ Action -> Mutation : get")
            return Observable.concat([
                .just(.setRefreshing(true)),
                self.provider.userService
                    .me()
                    .map { result in
                        switch result {
                        case let .success(response): return .setPolicy(response.policy)
                        case let .error(err): return .error(err)
                        }
                    },
                .just(.setRefreshing(false))
            ])
        // case logout
        case .logout:
            self.provider.preferencesService.isLogged = false
            return .just(.success("logout"))
        // delete
        case .delete:
            log.verbose("♻️ Action -> Mutation : delete")
            return self.provider.userService
                .delete()
                .map { result in
                    switch result {
                    case .success:
                        self.provider.preferencesService.isLogged = false
                        return .success("delete")
                    case let .error(err): return .error(err)
                    }
                }
        // data
        case .data:
            log.verbose("♻️ Action -> Mutation : data")
            return self.provider.userService
                .data()
                .map { result in
                    switch result {
                    case .success:
                        return .success("data")
                    case let .error(err): return .error(err)
                    }
                }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // set
        case let .set(user):
            log.verbose("♻️ Mutation -> State : set", user.email)
            state.error = nil
            state.user = user
        case let .setPolicy(policy):
            log.verbose("♻️ Mutation -> State : set policy")
            if policy != nil {
                state.policy = policy!
            }
        // work
        case let .setRefreshing(isRefreshing):
            log.verbose("♻️ Mutation -> State : setRefreshing")
            state.error = nil
            state.isRefreshing = isRefreshing
        // default
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.error = nil
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error")
            let _error: DisplayError = getDisplayError(error, self.provider.preferencesService.isLogged)
            self.provider.preferencesService.isLogged = _error.code == 401 ? false : true
            state.error = _error
        }
        return state
    }

    // reactor init

    func editReactor(_ user: User) -> UserViewReactor {
        return UserViewReactor(provider: self.provider, user: user)
    }

    func preferenceReactor(_ user: User, _ policy: UsersPolicy) -> UserPreferenceReactor {
        return UserPreferenceReactor(provider: self.provider, user: user, policy: policy)
    }

    func pageReactor(name: String) -> HomePageReactor {
        return HomePageReactor(provider: self.provider, api: .page(name), style: .classic, displayLinks: true)
    }

    func moreReactor() -> UserMoreReactor {
        return UserMoreReactor(provider: self.provider)
    }
}
