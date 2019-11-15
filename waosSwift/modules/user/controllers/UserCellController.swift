/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class UserCellController: CoreCellController, View {

    typealias Reactor = UserCellReactor

    // MARK: UI

    let labelFirstname = CoreUILabel().then {
        $0.numberOfLines = 2
    }

    // MARK: Initializing

    override func initialize() {
        self.contentView.addSubview(self.labelFirstname)
    }

    // MARK: Binding

    func bind(reactor: Reactor) {
        self.labelFirstname.text = reactor.currentState.firstName
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        self.labelFirstname.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.right.equalTo(25)
            make.top.equalTo(25)
            make.height.equalTo(25)
        }
        self.labelFirstname.sizeToFit()
    }
}
