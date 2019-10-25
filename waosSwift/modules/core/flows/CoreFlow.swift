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

        Flows.whenReady(flow1: tasksFlow, flow2: secondFlow) { [unowned self] (root1: UINavigationController, root2: UINavigationController) in

            root1.tabBarItem = UITabBarItem(title: L10n.get("Localizable", config["router"][0]["name"].string ?? ""), image: UIImage.fontAwesomeIcon(code: "fa-" + (config["router"][0]["meta"]["icon"].string ?? ""), style: .solid, textColor: .blue, size: CGSize(width: config["router"][0]["meta"]["width"].int ?? 0, height: config["router"][0]["meta"]["height"].int ?? 0)), selectedImage: nil)

            root2.tabBarItem = UITabBarItem(title: L10n.get("Localizable", config["router"][1]["name"].string ?? ""), image: UIImage.fontAwesomeIcon(code: "fa-" + (config["router"][1]["meta"]["icon"].string ?? ""), style: .solid, textColor: .blue, size: CGSize(width: config["router"][1]["meta"]["width"].int ?? 0, height: config["router"][1]["meta"]["height"].int ?? 0)), selectedImage: nil)

            self.rootViewController.setViewControllers([root1, root2], animated: false)
        }

        return .multiple(flowContributors: [.contribute(withNextPresentable: tasksFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.tasksIsRequired)),
                                            .contribute(withNextPresentable: secondFlow,
                                                        withNextStepper: OneStepper(withSingleStep: Steps.secondIsRequired))])
    }
}
