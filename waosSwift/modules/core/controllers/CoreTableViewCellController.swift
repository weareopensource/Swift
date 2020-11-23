import UIKit

class CoreTableViewCellController: UITableViewCell {

    // MARK: UI

    let error = MessageView.viewFromNib(layout: .cardView).then {
        $0.configureTheme(.error, iconStyle: .subtle)
        $0.backgroundView.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")?.withAlphaComponent(CGFloat(config["theme"]["popup"]["alpha"].float ?? 0.9))
        $0.button?.backgroundColor = .clear
        $0.button?.tintColor = UIColor.white.withAlphaComponent(0.5)
        $0.button?.setTitle("", for: .normal)
        $0.button?.setImage(UIImage.fontAwesomeIcon(code: "fa-paper-plane", style: .solid, textColor: .white, size: CGSize(width: 22, height: 22)), for: .normal)
    }
    var popupConfig = SwiftMessages.defaultConfig

    // MARK: Initializing

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
        // popup
        popupConfig.duration = .seconds(seconds: TimeInterval(Int(config["theme"]["popup"]["duration"].int ?? 3)))
        // constraints
        self.updateConstraintsIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        // Override point
    }

    // MARK: Rx

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: Layout Constraints

    private(set) var didSetupConstraints = false

    override func updateConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateConstraints()
    }

    func setupConstraints() {
        // Override point
    }

}

/**
 * Extension
 */

extension CoreTableViewCellController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
