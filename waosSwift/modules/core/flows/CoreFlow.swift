/**
 * Dependencies
 */

import UIKit
import RxFlow

/**
 * Flow
 */

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
        log.info("🗑 \(type(of: self))")
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
        let profilFlow = UserFlow(withServices: self.services)

        Flows.use([tasksFlow, secondFlow, profilFlow], when: .ready) { [unowned self] (root: [UINavigationController]) in

            for (index, route) in root.enumerated() {
                route.tabBarItem = UITabBarItem(title: L10n.get("Localizable", config["router"][index]["name"].string ?? ""), image: UIImage.fontAwesomeIcon(code: "fa-" + (config["router"][index]["meta"]["icon"].string ?? ""), style: .solid, textColor: .blue, size: CGSize(width: config["router"][index]["meta"]["width"].int ?? 0, height: config["router"][index]["meta"]["height"].int ?? 0)), selectedImage: nil)
            }

            self.rootViewController.setViewControllers(root, animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: tasksFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.tasksIsRequired)),
                                            .contribute(withNextPresentable: secondFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.secondIsRequired)),
                                            .contribute(withNextPresentable: profilFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.userIsRequired))])
    }
}
