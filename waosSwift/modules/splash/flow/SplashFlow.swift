/**
 * Dependencies
 */

import UIKit

/**
 * Flow
 */

final class SplashFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let services: AppServicesProvider

    init(withServices services: AppServicesProvider) {
        self.services = services
    }

    deinit {
        log.info("🗑 \(type(of: self))")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return .none }
        switch step {
        case .splashIsRequired:
            return navigateToSplashScreen()
        case .splashIsComplete(let result):
            if (result) {
                return .end(forwardToParentFlowWithStep: Steps.authIsComplete)
            } else {
                return .end(forwardToParentFlowWithStep: Steps.splashIsComplete(false))
            }
        default:
            return .none
        }
    }

    private func navigateToSplashScreen() -> FlowContributors {
        let provider = AppServicesProvider()
        let reactor = SplashReactor(provider: provider)
        let viewController = SplashController(reactor: reactor)
        viewController.title = "Splash"
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
