/**
 * Dependencies
 */

import ReactorKit

let contents: [String] = [L10n.onBoardingIntroduction, "toto", "titi"]

/**
 * Reactor
 */

final class OnboardingReactor: Reactor {

    // MARK: Constants

    // user actions
    enum Action {
        case complete
        case update(Int)
    }

    // state changes
    enum Mutation {
        case setContent(Int)
        case dismiss
    }

    // the current view state
    struct State {
        var content: String
        var isDismissed: Bool

        init() {
            self.content = contents[0]
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
        case .complete:
            self.provider.preferencesService.onBoarded = true
            return .just(.dismiss)
        case let .update(page):
            return .just(.setContent(page))
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setContent(page):
            state.content = contents[page]
        case .dismiss:
            state.isDismissed = true
        }
        return state
    }
}
