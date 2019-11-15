/**
 * Dependencies
 */

import UIKit

/**
 * Flow
 */

final class UserFlow: Flow {
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
        case .userIsRequired:
            return navigateToUserScreen()
        default:
            return .none
        }
    }

    private func navigateToUserScreen() -> FlowContributors {
        let provider = AppServicesProvider()
        let reactor = UserReactor(provider: provider)
        let viewController = UserController(reactor: reactor)
        viewController.title = L10n.userTitle
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: Steps.userIsRequired)))
    }
}
