/**
 * Dependencies
 */

import UIKit

/**
 * Flow
 */

final class ProfilFlow: Flow {
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
        case .profilIsRequired:
            return navigateToProfilScreen()
        default:
            return .none
        }
    }

    private func navigateToProfilScreen() -> FlowContributors {
        let reactor = ProfilReactor()
        let viewController = ProfilController(reactor: reactor)
        viewController.title = L10n.profilTitle
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: Steps.profilIsRequired)))
    }
}
