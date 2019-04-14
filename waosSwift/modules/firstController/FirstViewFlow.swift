import Foundation
import UIKit

final class FirstViewFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let services: AppServices

    init(withServices services: AppServices) {
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {

        guard let step = step as? SampleStep else { return FlowContributors.none }

        switch step {

        case .firstViewIsRequired:
            return navigateToFirstViewScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigateToFirstViewScreen() -> FlowContributors {
        let viewController = FirstViewController.instantiate()
        viewController.title = L10n.firstTitle

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SampleStep.firstViewIsRequired)))
    }
}
