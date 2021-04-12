/**
 * Dependencies
 */

import UIKit
import ReactorKit
import MessageUI
import SwiftMessages

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
        // error
        self.error.button?.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["mails"]["report"].string ?? "")])
                    mvc.setSubject(L10n.userReport)
                    mvc.setMessageBody(setMailError("\(reactor.currentState.error?.title ?? "") \n \(reactor.currentState.error?.description ?? "") \n  \(reactor.currentState.error?.source ?? "")"), isHTML: true)
                    self.present(mvc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: TasksViewReactor) {
        self.barButtonDone.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
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
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // error
        reactor.state
            .map { $0.error }
            .filterNil()
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.error.configureContent(title: error.title, body: error.description == "" ? error.title : error.description)
                self.error.button?.isHidden = (error.source != nil && error.code != 401) ? false : true
                SwiftMessages.hideAll()
                SwiftMessages.show(config: self.popupConfig, view: self.error)
            })
            .disposed(by: self.disposeBag)
    }
}
