import Foundation
import UIKit

final class SecondViewFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()
    private let services: AppServices

    init(withServices services: AppServices) {
        self.services = services
    }

    deinit {
    }

    func navigate(to step: Step) -> FlowContributors {

        guard let step = step as? SampleStep else { return FlowContributors.none }

        switch step {

        case .secondViewIsRequired:
            return navigateToSecondViewScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigateToSecondViewScreen() -> FlowContributors {
        let viewController = SecondViewController.instantiate()
        viewController.title = L10n.secondTitle

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SampleStep.secondViewIsRequired)))
    }
}