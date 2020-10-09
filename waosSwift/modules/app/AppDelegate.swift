import UIKit
import ReactorKit
import UserNotifications

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

        // MARK: Flow

        coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            log.debug("🚀 will nav to \(flow) & step \(step)")
        }).disposed(by: self.disposeBag)

        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            log.debug("🚀 did nav to \(flow) & step \(step)")
        }).disposed(by: self.disposeBag)

        self.appFlow = AppFlow(withWindow: window, andServices: self.servicesProvider)

        coordinator.coordinate(flow: self.appFlow, with: AppStepper(withServices: self.servicesProvider))

        // MARK: Toasts

        ToastView.appearance().backgroundColor = UIColor(named: config["theme"]["toast"]["background"].string ?? "")?.withAlphaComponent(CGFloat(config["theme"]["toast"]["alpha"].float ?? 1))
        ToastView.appearance().textColor = UIColor(named: config["theme"]["toast"]["text"].string ?? "")
        ToastView.appearance().font = UIFont.init(name: "Arial", size: 16)
        ToastView.appearance().textInsets = UIEdgeInsets(top: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)), left: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)), bottom: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)), right: (CGFloat(config["theme"]["toast"]["margin"].float ?? 10)))
        ToastView.appearance().cornerRadius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
        if NSString(string: config["theme"]["toast"]["bottom"].string ?? "").boolValue == true {
            ToastView.appearance().bottomOffsetPortrait = 100
            ToastView.appearance().bottomOffsetLandscape = 100
        } else {
            let marginTop: CGFloat = 170
            ToastView.appearance().bottomOffsetPortrait = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - marginTop
            ToastView.appearance().bottomOffsetLandscape = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - marginTop
        }

        // MARK: Notifications
        registerForPushNotifications()
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            log.debug("📱 Launched from notification notificationOption: \(String(describing: notificationOption))")
            log.debug("📱 Launched from notification aps: \(aps)")
            handleNotification(aps: aps)
        }

        return true
    }

    // MARK: Notifications
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        log.debug("📱 Device Token: \(token)")
    }

    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("📱 Failed to register: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        log.debug("📱 Received notification aps: \(aps)")
        if (UIApplication.shared.applicationState != .active) {
            handleNotification(aps: aps)
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            log.debug("📱 Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            log.debug("📱 Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func handleNotification(aps: [String: AnyObject]) {
        // handling instrucions => action:id
        if let instrucion = aps["link_url"] as? String {
            let action = instrucion.split(separator: ":")
            if action.count == 2 {
                NotificationCenter.default.post(name: Notification.Name(String(action[0])), object: nil, userInfo: ["id": String(action[1])])
            }
        }
    }

}
