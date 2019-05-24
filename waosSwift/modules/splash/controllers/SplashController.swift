/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

class SplashController: CoreController, View, Stepper {

    // MARK: UI

    let label = UILabel().then {
        $0.text = "LOLILOL"
        $0.textAlignment = .center
    }

    // MARK: Properties

    let steps = PublishRelay<Step>()

    // MARK: Initializing

    init(reactor: SplashReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.label)
    }

    override func setupConstraints() {
        label.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(250)
            make.center.equalTo(self.view)
        }
    }

    // MARK: Binding

    func bind(reactor: SplashReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension SplashController {

    // MARK: views (View -> View)

    func bindView(_ reactor: SplashReactor) {
        // Action
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.checkUserToken }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: SplashReactor) {}

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: SplashReactor) {}
}
