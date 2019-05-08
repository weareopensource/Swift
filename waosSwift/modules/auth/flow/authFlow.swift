/**
 * Dependencies
 */

import Foundation
import UIKit

/**
 * Flow
 */

final class AuthFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let services: ServicesProvider

    init(withServices services: ServicesProvider) {
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return FlowContributors.none }
        switch step {
        case .authIsRequired:
            return navigateToAuthScreen()
        case .authIsComplete:
            return .end(forwardToParentFlowWithStep: Steps.authIsComplete)
        default:
            return FlowContributors.none
        }
    }

    private func navigateToAuthScreen() -> FlowContributors {
        let provider = AppServicesProvider()
        let reactor = AuthSigninReactor(provider: provider)
        let viewController = AuthSignInController(reactor: reactor)
        viewController.title = "Auth"
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: Steps.authIsRequired)))
    }
}
