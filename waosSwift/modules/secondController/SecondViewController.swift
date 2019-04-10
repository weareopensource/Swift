import UIKit
import Reusable
import ReactorKit

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

private extension SecondViewController {
    func bindView(_ reactor: SecondViewReactor) {}
    func bindAction(_ reactor: SecondViewReactor) {}
    func bindState(_ reactor: SecondViewReactor) {}
}
