import UIKit

class CoreViewController: UIViewController {
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    var disposeBag = DisposeBag()

    deinit {
    }
}
