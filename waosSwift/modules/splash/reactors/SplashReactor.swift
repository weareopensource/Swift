/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class SplashReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case checkUserToken
    }

    // state changes
    enum Mutation {
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        init() {
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
        case .checkUserToken:
            log.verbose("♻️ Action -> Mutation : checkUserToken")
            let status = getTokenStatus()
            switch status {
            case .isOk:
                self.provider.preferencesService.isLogged = true
                return .just(.success("token ok"))
            case .toDefine:
                self.provider.preferencesService.isLogged = false
                return .just(.success("token to define"))
            case .toRenew:
                // if token expire time is more than X ms
                return self.provider.authService
                    .token()
                    .asObservable()
                    .map { result in
                        switch result {
                        case let .success(response):
                            UserDefaults.standard.set(response.tokenExpiresIn, forKey: "CookieExpire")
                            return .success("token renewed")
                        case let .error(err):
                            self.provider.preferencesService.isLogged = false
                            return .error(err)
                        }
                }
            }
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error")
            print("YESSSS \(error)")
        }
        return state
    }

}
