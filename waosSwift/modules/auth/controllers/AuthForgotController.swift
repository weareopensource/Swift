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

    let inputEmail = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.setFontAwesomeIcon("fa-envelope")
        $0.placeholder = L10n.authMail + "..."
        $0.autocapitalizationType = .none
        $0.textContentType = .username
        //$0.text = "test@waos.me"
    }
    let buttonReset = CoreUIButton().then {
        $0.setTitle(L10n.authReset, for: .normal)
        $0.setTitleColor(Metric.secondary, for: .normal)
    }
    let buttonSignin = CoreUIButton().then {
        $0.setTitle(L10n.authSignInTitle, for: .normal)
    }
    let labelErrors = CoreUILabel().then {
        $0.numberOfLines = 4
        $0.textAlignment = .center
        $0.textColor = UIColor.red
    }
    let labelSuccess = CoreUILabel().then {
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = Metric.secondary
    }

    // background
    let backgroundImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.alpha = 1
        $0.image = UIImage(named: "authBackground")
        $0.alpha = 0.4
    }
    let backgroundView = UIView().then {
        $0.backgroundColor = .clear
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
        // background
        self.view.addSubview(self.backgroundImage)
        self.view.addSubview(self.backgroundView)
        // content
        self.view.registerAutomaticKeyboardConstraints() // active layout with snapkit
        self.view.addSubview(self.inputEmail)
        self.view.addSubview(self.buttonReset)
        self.view.addSubview(self.buttonSignin)
        self.view.addSubview(self.labelErrors)
        self.view.addSubview(self.labelSuccess)
        // config
        self.view.backgroundColor = Metric.primary
        self.navigationController?.clear()
    }

    override func setupConstraints() {
        self.width = self.view.frame.width
        // inputs
        labelSuccess.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-90).keyboard(false, in: self.view)
        }
        labelSuccess.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-190).keyboard(true, in: self.view)
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
        buttonSignin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(-80)
            make.centerY.equalTo(self.view).offset(30).keyboard(false, in: self.view)
        }
        buttonSignin.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-70).keyboard(true, in: self.view)
        }
        buttonReset.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(80)
            make.centerY.equalTo(self.view).offset(30).keyboard(false, in: self.view)
        }
        buttonReset.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-70).keyboard(true, in: self.view)
        }
        labelErrors.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(120).keyboard(false, in: self.view)
        }
        labelErrors.snp.prepareConstraints {  (make) -> Void in
            make.centerY.equalTo(self.view).offset(20).keyboard(true, in: self.view)
        }
        // background
        self.backgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view.snp.width)
        }
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
        // button signin
        buttonSignin.rx.tap
            .map { _ in Reactor.Action.signIn }
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
        reactor.state
            .map { $0.success }
            .filter { $0 != "" && $0 != "email" }
            .distinctUntilChanged()
            .debounce(.milliseconds(7000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.buttonSignin.sendActions(for: .touchUpInside)
            })
            .disposed(by: self.disposeBag)
        // validation errors
        reactor.state
            .map { $0.errors }
            .filter { $0.count > 0 }
            .distinctUntilChanged { $0.count == $1.count }
            .subscribe(onNext: { errors in
                self.error.configureContent(title: "Schema", body: errors.map { "\($0.description)." }.joined(separator: "\n"))
                self.error.button?.isHidden = true
                SwiftMessages.show(config: self.popupConfig, view: self.error)
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.errors.count }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                if reactor.currentState.errors.firstIndex(where: { $0.title ==  "\(User.Validators.email)" }) != nil {
                    self.inputEmail.layer.borderWidth = 1.0
                } else {
                    self.inputEmail.layer.borderWidth = 0
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
