import Foundation
import UIKit

final class OnboardingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.topItem?.title = L10n.onBoardingTitle
        return viewController
    }()

    private let services: AppServices

    init(withServices services: AppServices) {
        self.services = services
    }

    deinit {
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SampleStep else { return .none }

        switch step {
        case .introIsRequired:
            return navigationToOnboardingIntroScreen()
        case .introIsComplete:
            return .end(forwardToParentFlowWithStep: SampleStep.onboardingIsComplete)
        default:
            return .none
        }
    }

    private func navigationToOnboardingIntroScreen() -> FlowContributors {
        let onboardingIntroViewController = OnboardingIntroViewController.instantiate()

        onboardingIntroViewController.title = L10n.onBoardingTitle
        self.rootViewController.pushViewController(onboardingIntroViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: onboardingIntroViewController,
                                                 withNextStepper: onboardingIntroViewController))
    }
}
