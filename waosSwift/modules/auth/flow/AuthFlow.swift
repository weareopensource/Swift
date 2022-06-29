/**
 * Dependencies
 */

import UIKit
import RxFlow

/**
 * Flow
 */

final class AuthFlow: Flow {
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
        case .authIsRequired:
            return navigateToAuthScreen()
        case .authIsComplete:
            return .end(forwardToParentFlowWithStep: Steps.authIsComplete)
        default:
            return .none
        }
    }

    private func navigateToAuthScreen() -> FlowContributors {
        let reactor = AuthSigninReactor(provider: self.services)
        let viewController = AuthSignInController(reactor: reactor)
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))

    }
}
