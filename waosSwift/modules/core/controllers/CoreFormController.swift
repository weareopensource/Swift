/**
 * Dependencies
 */

import UIKit
import RxSwift
import Eureka
import MessageUI
import SwiftyJSON
import SwiftMessages

/**
 * controller
 */

class CoreFormController: FormViewController {

    // MARK: Constants

    struct Metric {
        static let surface = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        static let onSurface = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
        static let primary = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
        static let onPrimary = UIColor(named: config["theme"]["themes"]["waos"]["onPrimary"].string ?? "")
        static let secondary = UIColor(named: config["theme"]["themes"]["waos"]["secondary"].string ?? "")
        static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
        static let onBackground = UIColor(named: config["theme"]["themes"]["waos"]["onBackground"].string ?? "")
        static let error = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")
        static let instagram = UIColor(named: config["theme"]["themes"]["waos"]["instagram"].string ?? "")
        static let twitter = UIColor(named: config["theme"]["themes"]["waos"]["twitter"].string ?? "")
        static let linkedin = UIColor(named: config["theme"]["themes"]["waos"]["linkedin"].string ?? "")
        static let facebook = UIColor(named: config["theme"]["themes"]["waos"]["facebook"].string ?? "")
        static let navigationBarTransparent = NSString(string: config["theme"]["navigationBar"]["transparent"].string ?? "").boolValue
        static let navigationBarShadow = NSString(string: config["theme"]["navigationBar"]["shadow"].string ?? "").boolValue
        static let tableViewRowHeight = CGFloat(config["theme"]["tableView"]["rowHeight"].int ?? 0)
        static let tableViewSectionHeaderHeight = CGFloat(config["theme"]["tableView"]["sectionHeaderHeight"].int ?? 0)
        static let tableViewSectionFooterHeight = CGFloat(config["theme"]["tableView"]["sectionFooterHeight"].int ?? 0)
        static let tabBarColor = NSString(string: config["theme"]["tabBar"]["color"].string ?? "").boolValue
        static let tabBarTintColor = NSString(string: config["theme"]["tabBar"]["tintColor"].string ?? "").boolValue
        static let tabBarTitle = NSString(string: config["theme"]["tabBar"]["title"].string ?? "").boolValue
        static let tabBarBorder = NSString(string: config["theme"]["tabBar"]["border"].string ?? "").boolValue
        static let imgCompression = CGFloat(config["img"]["compresion"].float ?? 1.0)
        static let imgMax = CGFloat(config["img"]["max"].float ?? 4096)
        static let margin = CGFloat(config["theme"]["global"]["margin"].int ?? 0)
        static let radius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
        static let timesButtonsThrottle = Int(config["times"]["buttons"]["throttle"].int ?? 2000)
        static let timesRefreshData = Int(config["times"]["refresh"]["data"].int ?? 60000)
        static let timesErrorsDebounce = Int(config["times"]["errors"]["debounce"].int ?? 2000)
        static let timesErrorsShort = Int(config["times"]["errors"]["short"].int ?? 500)
        static let avatar = CGFloat(100)
    }

    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    // MARK: UI

    let transparentNavigationBar = UINavigationBarAppearance().then {
        $0.configureWithTransparentBackground()
        $0.titleTextAttributes = [.foregroundColor: Metric.onPrimary!]
    }
    let defaultNavigationBar = UINavigationBarAppearance().then {
        $0.configureWithDefaultBackground()
        $0.backgroundColor = Metric.primary
        $0.titleTextAttributes = [.foregroundColor: Metric.onPrimary!]
    }
    
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

    // shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation
        if Metric.navigationBarTransparent == true {
            self.navigationController?.navigationBar.standardAppearance = self.transparentNavigationBar
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.transparentNavigationBar
        } else {
            self.navigationController?.navigationBar.standardAppearance = self.defaultNavigationBar
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.defaultNavigationBar
        }
        if Metric.navigationBarShadow == false {
            self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance.shadowColor = .clear
            self.transparentNavigationBar.shadowColor = .clear
        }
        self.navigationController?.navigationBar.tintColor = Metric.onPrimary
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
        // tableView
        self.tableView?.backgroundColor = Metric.background
        self.tableView?.rowHeight = Metric.tableViewRowHeight
        self.tableView?.sectionHeaderHeight = Metric.tableViewSectionHeaderHeight
        self.tableView?.sectionFooterHeight = Metric.tableViewSectionFooterHeight
        // self.tableView?.separatorStyle = .none // no border
        // popup
        popupConfig.duration = .seconds(seconds: TimeInterval(Int(config["theme"]["popup"]["duration"].int ?? 3)))
        // view
        self.view.backgroundColor = Metric.background

        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = Metric.onSurface
            cell.backgroundColor = Metric.surface

            if !row.isValid {
                cell.titleLabel?.textColor = Metric.error
            }
        }

        EmailRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = Metric.onSurface
            cell.backgroundColor = Metric.surface

            if !row.isValid {
                cell.titleLabel?.textColor = Metric.error
            }
        }

        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = Metric.onSurface
            cell.backgroundColor = Metric.surface
        }
    }

    // calc
    override func viewWillLayoutSubviews() {
        self.tableView?.separatorColor = Metric.surface?.darker(by: 8)
    }

}

/**
 * Extension
 */

extension CoreFormController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
