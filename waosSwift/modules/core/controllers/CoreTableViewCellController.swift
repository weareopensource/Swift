import UIKit

class CoreTableViewCellController: UITableViewCell {

    // MARK: Initializing

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
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
