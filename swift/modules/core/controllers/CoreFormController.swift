import UIKit
import Eureka

class CoreFormController: FormViewController {
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

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
        self.navigationController?.navigationBar.barTintColor = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: config["theme"]["themes"]["waos"]["onPrimary"].string ?? "")!]
        self.navigationController?.navigationBar.tintColor = UIColor(named: config["theme"]["themes"]["waos"]["onPrimary"].string ?? "")
        // tabar
        if NSString(string: config["theme"]["tabBar"]["color"].string ?? "").boolValue == true {
            self.tabBarController?.tabBar.barTintColor = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
            self.tabBarController?.tabBar.tintColor = UIColor(named: config["theme"]["themes"]["waos"]["onPrimary"].string ?? "")
        }
        if NSString(string: config["theme"]["tabBar"]["title"].string ?? "").boolValue != true {
            self.tabBarController?.tabBar.items?.forEach {
                $0.title = ""
                $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
        // tableView
        self.tableView?.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
        self.tableView?.rowHeight = CGFloat(config["theme"]["tableView"]["rowHeight"].int ?? 0)
        self.tableView?.sectionHeaderHeight = CGFloat(config["theme"]["tableView"]["sectionHeaderHeight"].int ?? 0)
        self.tableView?.sectionFooterHeight = CGFloat(config["theme"]["tableView"]["sectionFooterHeight"].int ?? 0)
        // self.tableView?.separatorStyle = .none // no border

        // view
        self.view.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")

        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
            cell.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")

            if !row.isValid {
                cell.titleLabel?.textColor = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")
            }
        }

        EmailRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
            cell.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")

            if !row.isValid {
                cell.titleLabel?.textColor = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")
            }
        }

        ButtonRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
            cell.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        }
    }

    // calc
    override func viewWillLayoutSubviews() {
        self.tableView?.separatorColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")?.darker(by: 8)
    }

}
