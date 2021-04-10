/**
 * Dependencies
 */

import UIKit
import RxSwift
import RxRelay
import ReactorKit
import AuthenticationServices
import RxFlow
import FontAwesome
import SwiftMessages
import MessageUI

/**
 * Controller
 */

final class AuthSignInController: CoreController, View, Stepper {

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
    let inputPassword = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.setFontAwesomeIcon("fa-key")
        $0.placeholder = L10n.authPassword + "..."
        $0.autocapitalizationType = .none
        $0.returnKeyType = .done
        $0.isSecureTextEntry = true
        $0.textContentType = .password
        //$0.text = "TestWaos@2019"
    }
    let buttonSignin = CoreUIButton().then {
        $0.setTitle(L10n.authSignInTitle, for: .normal)
        $0.setTitleColor(Metric.secondary, for: .normal)
    }
    let buttonSignup = CoreUIButton().then {
        $0.setTitle(L10n.authSignUpTitle, for: .normal)
    }
    let labelErrors = CoreUILabel().then {
        $0.numberOfLines = 4
        $0.textAlignment = .center
        $0.textColor = UIColor.red
    }
    let buttonForgot = UIButton().then {
        $0.setTitle(L10n.authForgot, for: .normal)
        $0.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        $0.backgroundColor = .clear
    }
    let buttonSignInApple = ASAuthorizationAppleIDButton().then {
        $0.isHidden = !(config["oAuth"]["apple"].bool ?? false)
        $0.cornerRadius = Metric.radius
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

    init(reactor: AuthSigninReactor) {
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
        self.view.addSubview(self.inputPassword)
        self.view.addSubview(self.buttonSignin)
        self.view.addSubview(self.buttonSignup)
        self.view.addSubview(self.labelErrors)
        self.view.addSubview(self.buttonForgot)
        self.view.addSubview(self.buttonSignInApple)
        // config
        self.view.backgroundColor = Metric.primary
        self.navigationController?.navigationBar.isHidden = true
    }

    override func setupConstraints() {
        self.width = self.view.frame.width
        // inputs
        inputEmail.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-60).keyboard(false, in: self.view)
        }
        inputEmail.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-160).keyboard(true, in: self.view)
        }
        inputPassword.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).keyboard(false, in: self.view)
        }
        inputPassword.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-100).keyboard(true, in: self.view)
        }
        // buttons
        buttonSignup.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(-80)
            make.centerY.equalTo(self.view).offset(60).keyboard(false, in: self.view)
        }
        buttonSignup.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-40).keyboard(true, in: self.view)
        }
        buttonSignin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(80)
            make.centerY.equalTo(self.view).offset(60).keyboard(false, in: self.view)
        }
        buttonSignin.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-40).keyboard(true, in: self.view)
        }
        labelErrors.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(120).keyboard(false, in: self.view)
        }
        buttonSignInApple.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).keyboard(false, in: self.view)
            make.centerY.equalTo(self.view).offset(140).keyboard(false, in: self.view)
        }
        buttonSignInApple.snp.prepareConstraints { (make) -> Void in
            make.right.equalTo(self.view.snp.left).keyboard(true, in: self.view)
            make.centerY.equalTo(self.view).offset(65).keyboard(true, in: self.view)
        }
        // errors
        labelErrors.snp.prepareConstraints {  (make) -> Void in
            make.centerY.equalTo(self.view).offset(20).keyboard(true, in: self.view)
        }
        // forgot
        buttonForgot.snp.makeConstraints {  (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-25)
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

    func bind(reactor: AuthSigninReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension AuthSignInController {

    // MARK: views (View -> View)

    func bindView(_ reactor: AuthSigninReactor) {
        // button signup
        self.buttonSignup.rx.tap
            .map(reactor.signUpReactor)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = AuthSignUpController(reactor: reactor)
                viewController.title = L10n.authSignUpTitle
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // button forgot
        self.buttonForgot.rx.tap
            .map(reactor.forgotReactor)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = AuthForgotController(reactor: reactor)
                viewController.title = L10n.authForgot
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
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

    func bindAction(_ reactor: AuthSigninReactor) {
        // button signin
        buttonSignin.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.signIn }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // button signin apple
        self.buttonSignInApple.rx
            .loginOnTap(scope: [.fullName, .email])
            .map { result in
                let auth = result.credential as! ASAuthorizationAppleIDCredential
                return Reactor.Action.oAuthApple(auth.fullName?.givenName ?? "", auth.fullName?.familyName ?? "", auth.email ?? "", auth.user)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // form
        Observable.combineLatest([self.inputEmail, self.inputPassword].map { $0.rx.text.orEmpty })
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
        // password
        self.inputPassword.rx.text
            .filter {($0?.count)! > 0}
            .map {Reactor.Action.updatePassword($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: AuthSigninReactor) {
        // refreshing
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        // validation errors
        reactor.state
            .map { $0.errors }
            .filter { $0.count > 0 }
            .distinctUntilChanged { $0.count == $1.count }
            .subscribe(onNext: { errors in
                self.error.configureContent(title: "Schema", body: errors.map { "\($0.description)." }.joined(separator: "\n"))
                self.error.button?.isHidden = true
                SwiftMessages.hideAll()
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
        .bind(to: self.buttonSignin.rx.isEnabled)
        .disposed(by: disposeBag)
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
