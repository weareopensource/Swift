/**
 * Dependencies
 */

import Foundation
import UIKit

/**
 * Flow
 */

final class TasksViewFlow: Flow {
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
        case .tasksListIsRequired:
            return navigateToTasksViewScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigateToTasksViewScreen() -> FlowContributors {
        let viewController = TasksListController.instantiate()
        viewController.title = L10n.firstTitle
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SampleStep.tasksListIsRequired)))
    }
}
