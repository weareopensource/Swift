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

    private let rootViewController = UINavigationController()
    private let services: AppServicesProvider

    init(withServices services: AppServicesProvider) {
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return .none }
        switch step {
        case .onboardingIsRequired:
            return navigationToOnboardingScreen()
        case .onboardingIsComplete:
            return .end(forwardToParentFlowWithStep: Steps.onboardingIsComplete)
        default:
            return .none
        }
    }

    private func navigationToOnboardingScreen() -> FlowContributors {
        let provider = AppServicesProvider()
        let reactor = OnboardingReactor(provider: provider)
        let viewController = OnboardingController(reactor: reactor)
        viewController.title = L10n.onBoardingTitle
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
