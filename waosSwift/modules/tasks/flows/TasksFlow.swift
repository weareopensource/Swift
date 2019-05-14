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
    private let services: AppServicesProvider

    init(withServices services: AppServicesProvider) {
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return .none }
        switch step {
        case .tasksIsRequired:
            return navigateToTasksScreen()
        default:
            return .none
        }
    }

    private func navigateToTasksScreen() -> FlowContributors {
        let provider = AppServicesProvider()
        let reactor = TasksListReactor(provider: provider)
        let viewController = TasksListController(reactor: reactor)
        viewController.title = L10n.taskTitle
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: OneStepper(withSingleStep: Steps.tasksIsRequired)))
    }
}
