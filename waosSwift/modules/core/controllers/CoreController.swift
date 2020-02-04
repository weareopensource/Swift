import UIKit

class CoreController: UIViewController {

    // MARK: Constants

    struct Metric {
        static let primary = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
        static let onPrimary = UIColor(named: config["theme"]["themes"]["waos"]["onPrimary"].string ?? "")
        static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
        static let tabBarColor = NSString(string: config["theme"]["tabBar"]["color"].string ?? "").boolValue
        static let tabBarTintColor = NSString(string: config["theme"]["tabBar"]["tintColor"].string ?? "").boolValue
        static let tabBarTitle = NSString(string: config["theme"]["tabBar"]["title"].string ?? "").boolValue
    }

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
            self.tabBarController?.tabBar.tintColor = Metric.primary
        }
        if Metric.tabBarTitle != true {
            self.tabBarController?.tabBar.items?.forEach {
               $0.title = ""
               $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            }
        }
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
