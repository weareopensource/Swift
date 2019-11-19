import UIKit

class CoreCollectionViewCellController: UICollectionViewCell {

    // MARK: Initializing

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      self.init(frame: .zero)
    }

    func initialize() {
        // Override point
    }

    // MARK: Rx

    var disposeBag: DisposeBag = DisposeBag()

}
