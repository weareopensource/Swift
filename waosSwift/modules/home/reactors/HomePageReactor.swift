/**
 * Dependencies
 */

import ReactorKit

/**
 * Reactor
 */

final class HomePageReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        // pages
        case get
    }

    // state changes
    enum Mutation {
        // pages
        case set([Pages])
        // inputs
        case setRefreshing(Bool)
        case success(String)
        case error(CustomError)
    }

    // the current view state
    struct State {
        // pages
        var pages: [Pages]
        // settings
        var displayLinks: Bool
        var style: markDownStyles
        // work
        var isRefreshing: Bool
        var errors: [DisplayError]
        var error: DisplayError?

        init(style: markDownStyles, displayLinks: Bool) {
            // pages
            self.pages = []
            // settings
            self.style = style
            self.displayLinks = displayLinks
            // work
            self.isRefreshing = false
            self.errors = []
        }
    }

    // MARK: Properties

    let provider: AppServicesProviderType
    let initialState: State
    let api: HomeApi

    // MARK: Initialization

    init(provider: AppServicesProviderType, api: HomeApi, style: markDownStyles = .air, displayLinks: Bool = true) {
        self.provider = provider
        self.api = api
        self.initialState = State(style: style, displayLinks: displayLinks)
    }

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .get:
            guard !self.currentState.isRefreshing else { return .empty() }
            log.verbose("♻️ Action -> Mutation : get")
            return Observable.concat([
                .just(.setRefreshing(true)),
                self.provider.homeService
                    .getPages(self.api)
                    .map { result in
                        switch result {
                        case let .success(result):
                            return .set(result.data)
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
        // refreshing
        case let .setRefreshing(isRefreshing):
            log.verbose("♻️ Mutation -> State : setRefreshing")
            state.isRefreshing = isRefreshing
        // set
        case let .set(pages):
            log.verbose("♻️ Mutation -> State : set")
            state.pages = pages
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
                _error = DisplayError(title: "SignIn", description: L10n.popupLogout, type: error.type, source: getRawError(error))
            } else {
                _error = DisplayError(title: error.message, description: (error.description ?? "Unknown error"), type: error.type, source: getRawError(error))
            }
            state.error = _error
        }
        return state
    }

}
