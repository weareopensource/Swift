/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class TaskCellController: CoreCellController, View {

    typealias Reactor = TaskCellReactor

    // MARK: UI

    let labelTitle = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 2
    }

    // MARK: Initializing

    override func initialize() {
        self.contentView.addSubview(self.labelTitle)
    }

    // MARK: Binding

    func bind(reactor: Reactor) {
        self.labelTitle.text = reactor.currentState.title
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        self.labelTitle.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.right.equalTo(25)
            make.top.equalTo(25)
            make.height.equalTo(25)
        }
        self.labelTitle.sizeToFit()
    }
}
