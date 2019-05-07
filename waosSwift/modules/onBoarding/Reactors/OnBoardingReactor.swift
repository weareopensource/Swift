/**
 * Dependencies
 */

import Foundation
import ReactorKit

let contents: [String] = [L10n.onBoardingIntroduction, "toto", "titi"]

/**
 * Reactor
 */

final class OnboardingReactor: Reactor, ServicesProviderType {

    // MARK: Constants

    // user actions
    enum Action {
        case complete
        case update(Int)
    }

    // state changes
    enum Mutation {
        case goToDashboard
        case setContent(Int)
    }

    // the current view state
    struct State {
        var step: Step = SampleStep.introIsRequired
        var content: String = contents[0]
    }

    // MARK: Properties

    let preferencesService = PreferencesService()
    let initialState = State()

    // MARK: Action -> Mutation (mutate() receives an Action and generates an Observable<Mutation>)

    func mutate(action: OnboardingReactor.Action) -> Observable<OnboardingReactor.Mutation> {
        switch action {
        case .complete:
            preferencesService.onBoarded = true
            return Observable.just(Mutation.goToDashboard)
        case let .update(page):
            return Observable.just(Mutation.setContent(page)).delay(0.1, scheduler: MainScheduler.instance)
        }
    }

    // MARK: Mutation -> State (reduce() generates a new State from a previous State and a Mutation)

    func reduce(state: OnboardingReactor.State, mutation: OnboardingReactor.Mutation) -> OnboardingReactor.State {
        var state = state
        switch mutation {
        case .goToDashboard:
            state.step = SampleStep.introIsComplete
            return state
        case let .setContent(page):
            state.content = contents[page]
            return state
        }
    }
}
