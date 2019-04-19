/**
 * Dependencies
 */

import Foundation
import ReactorKit

/**
 * Reactor
 */

final class OnboardingIntroViewReactor: Reactor, ServicesProviderType {

    // MARK: Constants

    // user actions
    enum Action {
        case introIsComplete
    }

    // state changes
    enum Mutation {
        case moveDashboard
    }

    // the current view state
    struct State {
        var step: Step = SampleStep.introIsRequired
    }

    // MARK: Properties

    let preferencesService = PreferencesService()
    let initialState = State()

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: OnboardingIntroViewReactor.Action) -> Observable<OnboardingIntroViewReactor.Mutation> {
        switch action {
        case .introIsComplete:
            preferencesService.onBoarded = true
            return Observable.just(Mutation.moveDashboard)
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: OnboardingIntroViewReactor.State, mutation: OnboardingIntroViewReactor.Mutation) -> OnboardingIntroViewReactor.State {
        var state = state
        switch mutation {
        case .moveDashboard:
            state.step = SampleStep.introIsComplete
            return state
        }
    }
}
