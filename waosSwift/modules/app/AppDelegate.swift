import UIKit
import ReactorKit

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

        // toast configuration
        ToastView.appearance().backgroundColor = UIColor(named: config["theme"]["toast"]["background"].string ?? "")?.withAlphaComponent(CGFloat(config["theme"]["toast"]["alpha"].float ?? 1))
        ToastView.appearance().textColor = UIColor(named: config["theme"]["toast"]["text"].string ?? "")
        ToastView.appearance().font = UIFont.init(name: "Arial", size: 16)
        ToastView.appearance().textInsets = UIEdgeInsets(top: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)), left: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)), bottom: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)), right: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)))
        ToastView.appearance().cornerRadius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
        if NSString(string: config["theme"]["toast"]["bottom"].string ?? "").boolValue == true {
            ToastView.appearance().bottomOffsetPortrait = 100
            ToastView.appearance().bottomOffsetLandscape = 100
        } else {
            let marginTop: CGFloat = 165
            ToastView.appearance().bottomOffsetPortrait = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - marginTop
            ToastView.appearance().bottomOffsetLandscape = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - marginTop
        }

        return true
    }

}
