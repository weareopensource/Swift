/**
 * Dependencies
 */

import UIKit
import Reusable
import ReactorKit

/**
 * Controller
 */

class TaskEditController: CoreViewController, StoryboardView, StoryboardBased {

    // MARK: Initializing

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Binding

    func bind(reactor: TaskEditReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

/**
 * Extensions
 */

private extension TaskEditController {

    // MARK: views (View -> View)

    func bindView(_ reactor: TaskEditReactor) {}

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: TaskEditReactor) {}

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: TaskEditReactor) {}
}
