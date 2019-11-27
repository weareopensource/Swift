import UIKit

class CoreCollectionViewCellController: UICollectionViewCell {

    // MARK: Initializing

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
        self.updateConstraintsIfNeeded()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      self.init(frame: .zero)
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
