import Foundation
import UIKit

final class TodoViewFlow: Flow {
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

        case .todoViewIsRequired:
            return navigateToTodoViewScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigateToTodoViewScreen() -> FlowContributors {
        let viewController = TodoViewController.instantiate()
        viewController.title = L10n.firstTitle

        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SampleStep.todoViewIsRequired)))
    }
}
