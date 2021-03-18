/**
 * Dependencies
 */

import UIKit
import RxFlow
import ReactorKit
import UserNotifications

/**
 * Delegate
 */

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

//        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
//            log.debug("🚀 will nav to \(flow) & step \(step)")
//        }).disposed(by: self.disposeBag)
//
//        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
//            log.debug("🚀 did nav to \(flow) & step \(step)")
//        }).disposed(by: self.disposeBag)

        self.appFlow = AppFlow(withWindow: window, andServices: self.servicesProvider)

        coordinator.coordinate(flow: self.appFlow, with: AppStepper(withServices: self.servicesProvider))

        // MARK: Notifications

        if(config["notifications"].bool ?? false) {
            registerForPushNotifications()
            let notificationOption = launchOptions?[.remoteNotification]
            if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
                log.verbose("📱 Launched from notification notificationOption: \(String(describing: notificationOption))")
                log.verbose("📱 Launched from notification aps: \(aps)")
                handleNotification(aps: aps)
            }
        }

        return true
    }

    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        // MARK: Notifications

        if(config["notifications"].bool ?? false) {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let token = tokenParts.joined()
            log.verbose("📱 Device Token: \(token)")
            self.servicesProvider.userService.updateDeviceToken(token)
        }
    }

    func application( _ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        // MARK: Notifications

        if(config["notifications"].bool ?? false) {
            log.error("📱 Failed to register: \(error)")
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {

        // MARK: Notifications

        if(config["notifications"].bool ?? false) {
            guard let aps = userInfo["aps"] as? [String: AnyObject] else {
                completionHandler(.failed)
                return
            }
            log.debug("📱 Received notification aps: \(aps)")
            if (UIApplication.shared.applicationState != .active) {
                handleNotification(aps: aps)
            }
        }
    }

    // MARK: Notifications

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            log.verbose("📱 Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            log.verbose("📱 Notification settings: \(settings)")
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
