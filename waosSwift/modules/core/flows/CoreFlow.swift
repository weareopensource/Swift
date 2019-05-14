import Foundation
import UIKit

final class CoreFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    let rootViewController = UITabBarController()
    private let services: AppServicesProvider

    init(withServices services: AppServicesProvider) {
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return FlowContributors.none }

        switch step {
        case .dashboardIsRequired:
            return navigateToDashboard()
        default:
            return .none
        }
    }

    private func navigateToDashboard() -> FlowContributors {
        let tasksFlow = TasksFlow(withServices: self.services)
        let secondFlow = SecondFlow(withServices: self.services)

        Flows.whenReady(flow1: tasksFlow, flow2: secondFlow) { [unowned self] (root1: UINavigationController, root2: UINavigationController) in
            let tabBarItem1 = UITabBarItem(title: L10n.taskTitle, image: nil, selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: L10n.secondTitle, image: nil, selectedImage: nil)

            root1.tabBarItem = tabBarItem1
            root1.title = L10n.taskTitle
            root2.tabBarItem = tabBarItem2
            root2.title = L10n.secondTitle

            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: tasksFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.tasksIsRequired)),
                                            .contribute(withNextPresentable: secondFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.secondIsRequired))])
    }
}
