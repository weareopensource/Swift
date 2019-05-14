import UIKit
import ReactorKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let disposeBag = DisposeBag() // ReactorKit
    var coordinator = FlowCoordinator() //that handles the navigation between Flows.
    var appFlow: AppFlow! // represents the main navigation

    lazy var servicesProvider = {
        return AppServicesProvider()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let window = self.window else { return false }

        coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            log.debug("🚀 will nav to \(flow) & step \(step)")
        }).disposed(by: self.disposeBag)

        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            log.debug("🚀 did nav to \(flow) & step \(step)")
        }).disposed(by: self.disposeBag)

        self.appFlow = AppFlow(withWindow: window, andServices: self.servicesProvider)

        coordinator.coordinate(flow: self.appFlow, with: AppStepper(withServices: self.servicesProvider))

        return true
    }
}
