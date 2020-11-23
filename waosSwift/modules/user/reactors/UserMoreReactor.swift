/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class UserMoreReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // default
        case done
    }

    // state changes
    enum Mutation {
        // inputs
        case dismiss
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        var isDismissed: Bool
        var errors: [DisplayError]
        var error: DisplayError?

        init() {
            self.isDismissed = false
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
        // done
        case .done:
            return .just(.dismiss)
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        // dissmiss
        case .dismiss:
            log.verbose("♻️ Mutation -> State : dismiss")
            state.isDismissed = true
            state.errors = []
        // success
        case let .success(success):
            log.verbose("♻️ Mutation -> State : succes \(success)")
            state.error = nil
            state.errors = purgeErrors(errors: state.errors, specificTitles: [success])
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            let _error: DisplayError = getDisplayError(error, self.provider.preferencesService.isLogged)
            self.provider.preferencesService.isLogged = _error.code == 401 ? false : true
            state.error = _error
        }
        return state
    }

    func pageReactor(name: String) -> HomePageReactor {
        return HomePageReactor(provider: self.provider, api: .page(name), style: .classic, displayLinks: true)
    }

    func changelogReactor() -> HomePageReactor {
        return HomePageReactor(provider: self.provider, api: .changelogs, style: .air, displayLinks: false)
    }
}
