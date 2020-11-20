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
            state.errors = purgeErrors(errors: state.errors, specificTitles: [success])
        // error
        case let .error(error):
            log.verbose("♻️ Mutation -> State : error \(error)")
            let _error: DisplayError
            if error.code == 401 {
                self.provider.preferencesService.isLogged = false
                _error = DisplayError(title: "jwt", description: "Wrong Password or Email.", type: error.type)
            } else {
                _error = DisplayError(title: error.message, description: (error.description ?? "Unknown error"), type: error.type)
            }
            ToastCenter.default.cancelAll()
            Toast(text: _error.description, delay: 0, duration: Delay.long).show()
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
