/**
 * Dependencies
 */

import UIKit
import ReactorKit
import RxFlow
import RxRelay
import SwiftMessages
import MessageUI

/**
 * Controller
 */

final class AuthForgotController: CoreController, View, Stepper {

    var width: CGFloat = 0

    // MARK: UI
    
    let barButtonClose = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)

    let inputEmail = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.placeholder = L10n.authMail + "..."
        $0.autocapitalizationType = .none
        $0.textContentType = .username
        $0.icon="fa-envelope"
        //$0.text = "test@waos.me"
    }
    let buttonReset = CoreUIButton().then {
        $0.setTitle(L10n.authReset, for: .normal)
        $0.setTitleColor(Metric.secondary, for: .normal)
    }
    let labelErrors = CoreUILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = Metric.onPrimary
    }
    let labelSuccess = CoreUILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = Metric.secondary
    }

    // background
    let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "authBackground")
        $0.alpha = 0.4
    }

    // MARK: Properties

    let steps = PublishRelay<Step>()

    // MARK: Initializing

    init(reactor: AuthForgotReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation
        self.navigationController?.navigationBar.standardAppearance = self.transparentNavigationBar
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.transparentNavigationBar
        // background
        self.view.addSubview(self.backgroundImage)
        // content
        self.view.registerAutomaticKeyboardConstraints() // active layout with snapkit
        self.view.addSubview(self.inputEmail)
        self.view.addSubview(self.buttonReset)
        self.view.addSubview(self.labelErrors)
        self.view.addSubview(self.labelSuccess)
        // config
        self.navigationController?.clear()
        self.view.backgroundColor = Metric.primary
        self.navigationItem.rightBarButtonItem = self.barButtonClose
    }

    override func setupConstraints() {
        self.width = self.view.frame.width
        // errors
        labelErrors.snp.makeConstraints {  (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.inputEmail.snp.top).offset(-10)
        }
        // inputs
        labelSuccess.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.inputEmail.snp.top).offset(-10)
        }
        inputEmail.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-30).keyboard(false, in: self.view)
        }
        inputEmail.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-130).keyboard(true, in: self.view)
        }
        buttonReset.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.inputEmail.snp.bottom).offset(10)
        }
        // background
        self.backgroundImage.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(self.view.frame.height + self.width/5)
        }
    }

    // MARK: Binding

    func bind(reactor: AuthForgotReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension AuthForgotController {

    // MARK: views (View -> View)

    func bindView(_ reactor: AuthForgotReactor) {
        // cancel
        self.barButtonClose.rx.tap
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

    func bindAction(_ reactor: AuthForgotReactor) {
        // button signin
        buttonReset.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.reset }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // form
        Observable.combineLatest([self.inputEmail].map { $0.rx.text.orEmpty })
            .map { $0.map { $0.isEmpty } }
            .map {Reactor.Action.updateIsFilled(!$0.contains(true))}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        // email
        self.inputEmail.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateEmail($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputEmail.rx.controlEvent(.editingChanged).asObservable()
            .debounce(.milliseconds(Metric.timesErrorsDebounce), scheduler: MainScheduler.instance)
            .map {Reactor.Action.validateEmail}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: AuthForgotReactor) {
        // refreshing
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
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
        // success
        reactor.state
            .map { $0.success }
            .filter { $0 != "" && $0 != "email" }
            .distinctUntilChanged()
            .debounce(.milliseconds(2000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { success in
                self.labelSuccess.text = success
            })
            .disposed(by: self.disposeBag)
        // validation errors
        reactor.state
            .map { $0.errors.count }
            .distinctUntilChanged()
            .subscribe(onNext: { count in
                if(count > 0) {
                    self.labelErrors.text = reactor.currentState.errors.first?.description
                } else {
                    self.labelErrors.text = ""
                }
                if reactor.currentState.errors.firstIndex(where: { $0.title ==  "\(User.Validators.email)" }) != nil {
                    self.inputEmail.error()
                } else {
                    self.inputEmail.valid()
                }
            })
            .disposed(by: self.disposeBag)
        Observable.combineLatest(
            reactor.state
                .map { $0.errors.count > 0 }
                .distinctUntilChanged(),
            reactor.state
                .map { !$0.isFilled }
                .distinctUntilChanged()
        )
        .map { [$0.0, $0.1] }
        .map { !$0.contains(true) }
        .bind(to: self.buttonReset.rx.isEnabled)
        .disposed(by: disposeBag)
        // error
        reactor.state
            .map { $0.error }
            .filterNil()
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.error.configureContent(title: error.title, body: error.description == "" ? error.title : error.description)
                self.error.button?.isHidden = (error.source != nil && error.code != 401) ? false : true
                SwiftMessages.show(config: self.popupConfig, view: self.error)
            })
            .disposed(by: self.disposeBag)
    }
}
