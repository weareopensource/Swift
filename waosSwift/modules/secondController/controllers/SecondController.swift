/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

class SecondController: CoreController, View {

    // MARK: UI

    let label = CoreUILabel().then {
        $0.text = L10n.secondTitle
        $0.textAlignment = .center
    }

    // MARK: Initializing

    init(reactor: SecondReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.label)
    }

    override func setupConstraints() {
        label.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(250)
            make.center.equalTo(self.view)
        }
    }

    // MARK: Binding

    func bind(reactor: SecondReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension SecondController {

    // MARK: views (View -> View)

    func bindView(_ reactor: SecondReactor) {}

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: SecondReactor) {}

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: SecondReactor) {}
}
