/**
 * Dependencies
 */

import UIKit
import ReactorKit
import Eureka

/**
 * Controller
 */

class UserPreferenceController: CoreFormController, View, NVActivityIndicatorViewable {

    // MARK: UI

    let barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let barButtonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

    // inputs
    let switchBackground = SwitchRow {
        $0.title = L10n.userPreferencesBackground
    }

    // MARK: Initializing

    init(reactor: UserPreferenceReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        form
            +++ Section(header: L10n.userPreferencesSection, footer: "")
            <<< self.switchBackground

        self.navigationItem.leftBarButtonItem = self.barButtonCancel
        self.navigationItem.rightBarButtonItem = self.barButtonDone
        self.view.addSubview(self.tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Binding

    func bind(reactor: UserPreferenceReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }

}

/**
 * Extensions
 */

private extension UserPreferenceController {

    // MARK: views (View -> View)

    func bindView(_ reactor: UserPreferenceReactor) {
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
                    mvc.setMessageBody(setMailError(reactor.currentState.error?.source), isHTML: true)
                    self.present(mvc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: UserPreferenceReactor) {
        // buttons
        self.barButtonDone.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // inputs
        self.switchBackground.rx.text
            .filterNil()
            .asObservable()
            .map {Reactor.Action.updateBackground($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: UserPreferenceReactor) {
        // inputs
        reactor.state
            .map { $0.background }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.switchBackground.value = reactor.currentState.background
                self.switchBackground.updateCell()
            })
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
            .map { $0.error }
            .filterNil()
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.error.configureContent(title: error.title, body: error.description)
                self.error.button?.isHidden = (error.source != nil && error.code != 401) ? false : true
                SwiftMessages.hideAll()
                SwiftMessages.show(config: self.popupConfig, view: self.error)
            })
            .disposed(by: self.disposeBag)
    }
}
