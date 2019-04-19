import Foundation
import ReactorKit

final class OnboardingIntroViewReactor: Reactor, ServicesProviderType {
    let preferencesService = PreferencesService()

    enum Action {
        case introIsComplete
    }

    enum Mutation {
        case moveDashboard
    }

    struct State {
        var step: Step = SampleStep.introIsRequired
    }

    let initialState = State()

    func mutate(action: OnboardingIntroViewReactor.Action) -> Observable<OnboardingIntroViewReactor.Mutation> {
        switch action {
        case .introIsComplete:
            preferencesService.onBoarded = true
            return Observable.just(Mutation.moveDashboard)
        }
    }

    func reduce(state: OnboardingIntroViewReactor.State, mutation: OnboardingIntroViewReactor.Mutation) -> OnboardingIntroViewReactor.State {
        var state = state
        switch mutation {
        case .moveDashboard:
            state.step = SampleStep.introIsComplete
            return state
        }
    }
}
