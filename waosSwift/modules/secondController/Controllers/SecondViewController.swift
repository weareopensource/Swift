/**
 * Dependencies
 */

import UIKit
import Reusable
import ReactorKit

/**
 * Controller
 */

class SecondViewController: CoreViewController, StoryboardView, StoryboardBased {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: SecondViewReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

/**
 * Extensions
 */

private extension SecondViewController {

    // MARK: views (View -> View)

    func bindView(_ reactor: SecondViewReactor) {}

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: SecondViewReactor) {}

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: SecondViewReactor) {}
}
