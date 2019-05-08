/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class TaskController: CoreController, View {

    // MARK: Constants

    let mode: Mode

    // MARK: UI

    // edit
    let titleInput = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "Do something..."
    }
    let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

    // MARK: Initializing

    init(reactor: TaskReactor) {
        self.mode = reactor.currentState.mode
        super.init()
        self.navigationItem.leftBarButtonItem = self.cancelButtonItem
        self.navigationItem.rightBarButtonItem = self.doneButtonItem
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.titleInput)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.titleInput.becomeFirstResponder()
    }

    override func setupConstraints() {
        titleInput.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(50)
            make.height.equalTo(50)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
    }

    // MARK: Binding

    func bind(reactor: TaskReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

/**
 * Extensions
 */

private extension TaskController {

    // MARK: views (View -> View)

    func bindView(_ reactor: TaskReactor) {
        // cancel
        self.cancelButtonItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: TaskReactor) {
        self.doneButtonItem.rx.tap
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        self.titleInput.rx.text
            .filterNil()
            .map(Reactor.Action.updateTitle)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: TaskReactor) {
        // title
        reactor.state.asObservable()
            .map { $0.task.title }
            .distinctUntilChanged()
            .bind(to: self.titleInput.rx.text)
            .disposed(by: self.disposeBag)
        // dissmiss
        reactor.state.asObservable()
            .map { $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
}
