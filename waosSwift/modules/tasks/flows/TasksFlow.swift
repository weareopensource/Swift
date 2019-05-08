/**
 * Dependencies
 */

import Foundation
import UIKit

/**
 * Flow
 */

final class TasksFlow: Flow {
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
        case .tasksIsRequired:
            return navigateToTasksScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigateToTasksScreen() -> FlowContributors {
        let provider = AppServicesProvider()
        let reactor = TasksListReactor(provider: provider)
        let viewController = TasksListController(reactor: reactor)
        viewController.title = L10n.taskTitle
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: SampleStep.tasksIsRequired)))
    }
}
