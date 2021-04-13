/**
 * Dependencies
 */

import UIKit
import RxSwift
import SwiftMessages
import FontAwesome
import MessageUI

/**
 * Dependencies
 */

class CoreController: UIViewController {

    // MARK: Constants

    struct Metric {
        static let primary = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
        static let onPrimary = UIColor(named: config["theme"]["themes"]["waos"]["onPrimary"].string ?? "")
        static let secondary = UIColor(named: config["theme"]["themes"]["waos"]["secondary"].string ?? "")
        static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
        static let onBackground = UIColor(named: config["theme"]["themes"]["waos"]["onBackground"].string ?? "")
        static let tabBarColor = NSString(string: config["theme"]["tabBar"]["color"].string ?? "").boolValue
        static let tabBarTintColor = NSString(string: config["theme"]["tabBar"]["tintColor"].string ?? "").boolValue
        static let tabBarTitle = NSString(string: config["theme"]["tabBar"]["title"].string ?? "").boolValue
        static let tabBarBorder = NSString(string: config["theme"]["tabBar"]["border"].string ?? "").boolValue
        static let timesButtonsThrottle = Int(config["times"]["buttons"]["throttle"].int ?? 2000)
        static let timesErrorsDebounce = Int(config["times"]["errors"]["debounce"].int ?? 2000)
        static let timesRefreshData = Int(config["times"]["refresh"]["data"].int ?? 60000)
        static let margin = Int(config["theme"]["global"]["margin"].int ?? 15)
        static let error = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")
        static let radius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
    }

    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    // MARK: UI

    let error = MessageView.viewFromNib(layout: .cardView).then {
        $0.configureTheme(.error, iconStyle: .subtle)
        $0.backgroundView.backgroundColor = Metric.error?.withAlphaComponent(CGFloat(config["theme"]["popup"]["alpha"].float ?? 0.9))
        $0.button?.backgroundColor = .clear
        $0.button?.tintColor = UIColor.white.withAlphaComponent(0.5)
        $0.button?.setTitle("", for: .normal)
        $0.button?.setImage(UIImage.fontAwesomeIcon(code: "fa-paper-plane", style: .solid, textColor: .white, size: CGSize(width: 22, height: 22)), for: .normal)
    }
    var popupConfig = SwiftMessages.defaultConfig

    // MARK: Initializing

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    // MARK: Rx

    var disposeBag = DisposeBag()

    // MARK: deinit

    deinit {
        log.info("🗑 deinit -> \(self.className)")
    }

    // MARK: viewDidLoad

    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
        self.navigationController?.navigationBar.barTintColor = Metric.primary
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Metric.onPrimary!]
        self.navigationController?.navigationBar.tintColor = Metric.onPrimary
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // tabar
        if Metric.tabBarColor == true {
            self.tabBarController?.tabBar.barTintColor = Metric.primary
            self.tabBarController?.tabBar.tintColor = Metric.onPrimary
        }
        if Metric.tabBarTintColor == true {
            self.tabBarController?.tabBar.tintColor = Metric.onBackground
        }
        if Metric.tabBarTitle != true {
            self.tabBarController?.tabBar.items?.forEach {
               $0.title = ""
               $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
        if Metric.tabBarBorder == false {
            self.tabBarController?.tabBar.layer.borderColor = UIColor.clear.cgColor
            self.tabBarController?.tabBar.clipsToBounds = true
        }
        // popup
        popupConfig.duration = .seconds(seconds: TimeInterval(Int(config["theme"]["popup"]["duration"].int ?? 3)))
        // view
        self.view.backgroundColor = Metric.background
    }

    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false

    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setupConstraints() {
        // Override point
    }
}

/**
 * Extension
 */

extension CoreController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
