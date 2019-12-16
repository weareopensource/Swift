/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class TasksViewController: CoreController, View {

    // MARK: Constants

    let mode: TasksViewMode

    // MARK: UI

    let inputTitle = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.placeholder = "Do something..."
    }
    let barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let barButtonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

    // MARK: Initializing

    init(reactor: TasksViewReactor) {
        self.mode = reactor.currentState.mode
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.barButtonCancel
        self.navigationItem.rightBarButtonItem = self.barButtonDone
        self.view.addSubview(self.inputTitle)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputTitle.becomeFirstResponder()
    }

    override func setupConstraints() {
        inputTitle.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.height.equalTo(50)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
    }

    // MARK: Binding

    func bind(reactor: TasksViewReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

/**
 * Extensions
 */

private extension TasksViewController {

    // MARK: views (View -> View)

    func bindView(_ reactor: TasksViewReactor) {
        // cancel
        self.barButtonCancel.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: TasksViewReactor) {
        self.barButtonDone.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.inputTitle.rx.text
            .filterNil()
            .skip(1)
            .map(Reactor.Action.updateTitle)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: TasksViewReactor) {
        // title
        reactor.state
            .map { $0.task.title }
            .distinctUntilChanged()
            .bind(to: self.inputTitle.rx.text)
            .disposed(by: self.disposeBag)
        // dissmissed
        reactor.state
            .map { $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // error
        reactor.state
            .map { $0.error?.description }
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .filterNil()
            .subscribe(onNext: { result in
                Toast(text: result, delay: 0, duration: Delay.long).show()
            })
            .disposed(by: self.disposeBag)
    }
}
