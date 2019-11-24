import UIKit

class CoreTableViewCellController: UITableViewCell {

    // MARK: Initializing

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        // Override point
    }

    // MARK: Rx

    var disposeBag: DisposeBag = DisposeBag()

}