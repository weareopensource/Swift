import UIKit

final class AppFlow: Flow {

    var root: Presentable {
        return self.rootWindow
    }

    private let rootWindow: UIWindow
    private let services: AppServicesProvider

    init(withWindow window: UIWindow, andServices services: AppServicesProvider) {
        self.rootWindow = window
        self.services = services
    }

    deinit {
        log.info("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? Steps else { return FlowContributors.none }

        switch step {
        case .onboardingIsRequired:
            return navigationToOnboardingScreen()
        case .onboardingIsComplete, .authIsRequired:
            return navigationToAuthScreen()
        case .authIsComplete, .dashboardIsRequired:
            return navigationToDashboardScreen()
        default:
            return FlowContributors.none
        }
    }

    private func navigationToOnboardingScreen() -> FlowContributors {
        if let rootViewController = self.rootWindow.rootViewController {
            rootViewController.dismiss(animated: false)
        }
        let onboardingFlow = OnboardingFlow(withServices: self.services)
        Flows.whenReady(flow1: onboardingFlow) { [unowned self] (root) in
            self.rootWindow.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: onboardingFlow, withNextStepper: OneStepper(withSingleStep: Steps.onboardingIsRequired)))
    }

    private func navigationToAuthScreen() -> FlowContributors {
        if let rootViewController = self.rootWindow.rootViewController {
            rootViewController.dismiss(animated: false)
        }
        let authFlow = AuthFlow(withServices: self.services)
        Flows.whenReady(flow1: authFlow) { [unowned self] (root) in
            self.rootWindow.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: authFlow, withNextStepper: OneStepper(withSingleStep: Steps.authIsRequired)))
    }

    private func navigationToDashboardScreen() -> FlowContributors {
        let coreFlow = CoreFlow(withServices: self.services)
        Flows.whenReady(flow1: coreFlow) { [unowned self] (root) in
            self.rootWindow.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: coreFlow, withNextStepper: OneStepper(withSingleStep: Steps.dashboardIsRequired)))
    }
}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let servicesProvider: AppServicesProvider
    private let disposeBag = DisposeBag()

    init(withServices services: AppServicesProvider) {
        self.servicesProvider = services
    }

    var initialStep: Step {
        return Steps.onboardingIsRequired
    }

    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
    func readyToEmitSteps() {
        self.servicesProvider
            .preferencesService.rx
            .onBoarded
            .debug()
            .map { $0 ? Steps.onboardingIsComplete : Steps.onboardingIsRequired }
            .debug()
            .bind(to: self.steps)
            .disposed(by: self.disposeBag)
    }
}
