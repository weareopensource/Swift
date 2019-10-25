import UIKit

class CoreController: UIViewController {
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

    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false

    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
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
        // view
        self.view.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
    }

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
