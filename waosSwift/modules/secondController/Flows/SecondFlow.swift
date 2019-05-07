/**
 * Dependencies
 */

import Foundation
import UIKit

/**
 * Flow
 */

final class SecondFlow: Flow {
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

        guard let step = step as? SampleStep else { return FlowContributors.none }

        switch step {

        case .secondIsRequired:
            return navigateToSecondScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigateToSecondScreen() -> FlowContributors {
        let reactor = SecondReactor()
        let viewController = SecondController(reactor: reactor)
        viewController.title = L10n.secondTitle
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SampleStep.secondIsRequired)))
    }
}
