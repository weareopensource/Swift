import UIKit
import Reusable
import ReactorKit

class TodoViewController: CoreViewController, StoryboardView, StoryboardBased {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: TodoViewReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

private extension TodoViewController {
    func bindView(_ reactor: TodoViewReactor) {}
    func bindAction(_ reactor: TodoViewReactor) {}
    func bindState(_ reactor: TodoViewReactor) {}
}
