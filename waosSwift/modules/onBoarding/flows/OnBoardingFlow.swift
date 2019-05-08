/**
 * Dependencies
 */

import Foundation
import UIKit

/**
 * Flow
 */

final class OnboardingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.topItem?.title = L10n.onBoardingTitle
        return viewController
    }()

    private let services: ServicesProvider

    init(withServices services: ServicesProvider) {
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
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
        let reactor = OnboardingReactor()
        let viewController = OnboardingController(reactor: reactor)
        viewController.title = L10n.onBoardingTitle
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
