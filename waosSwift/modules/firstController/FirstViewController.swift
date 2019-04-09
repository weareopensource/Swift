import UIKit
import Reusable
import ReactorKit

class FirstViewController: CoreViewController, StoryboardView, StoryboardBased {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: FirstViewReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

private extension FirstViewController {
    func bindView(_ reactor: FirstViewReactor) {}
    func bindAction(_ reactor: FirstViewReactor) {}
    func bindState(_ reactor: FirstViewReactor) {}
}
