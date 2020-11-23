/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class AuthSignUpController: CoreController, View, Stepper, NVActivityIndicatorViewable {

    var width: CGFloat = 0
    var isPasswordValid: Bool = false

    // MARK: UI

    let inputFirstName = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.setFontAwesomeIcon("fa-user")
        $0.placeholder = L10n.authFirstname + "..."
    }
    let inputLastName = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.setFontAwesomeIcon("fa-user")
        $0.placeholder = L10n.authLastname + "..."
    }
    let inputEmail = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.setFontAwesomeIcon("fa-envelope")
        $0.placeholder = L10n.authMail + "..."
        $0.autocapitalizationType = .none
        $0.textContentType = .username
    }
    let inputPassword = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.setFontAwesomeIcon("fa-key")
        $0.placeholder = L10n.authPassword + "..."
        $0.autocapitalizationType = .none
        $0.returnKeyType = .done
        $0.isSecureTextEntry = true
        $0.textContentType = .password
    }
    let progressPassword = UIProgressView().then {
        $0.setProgress(0, animated: true)
    }

    let buttonSignin = CoreUIButton().then {
        $0.setTitle(L10n.authSignInTitle, for: .normal)
    }
    let buttonSignup = CoreUIButton().then {
        $0.setTitle(L10n.authSignUpTitle, for: .normal)
        $0.setTitleColor(Metric.secondary, for: .normal)
    }
    let labelErrors = CoreUILabel().then {
        $0.numberOfLines = 5
        $0.textAlignment = .center
        $0.textColor = UIColor.red
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

    init(reactor: AuthSignUpReactor) {
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
        self.view.addSubview(self.inputFirstName)
        self.view.addSubview(self.inputLastName)
        self.view.addSubview(self.inputEmail)
        self.view.addSubview(self.inputPassword)
        self.view.addSubview(self.progressPassword)
        self.view.addSubview(self.buttonSignin)
        self.view.addSubview(self.buttonSignup)
        self.view.addSubview(self.labelErrors)
        // config
        self.view.backgroundColor = Metric.primary
    }

    override func setupConstraints() {
        self.width = self.view.frame.width
        // inputs
        inputFirstName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-120).keyboard(false, in: self.view)
        }
        inputFirstName.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-220).keyboard(true, in: self.view)
        }
        inputLastName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-60).keyboard(false, in: self.view)
        }
        inputLastName.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-160).keyboard(true, in: self.view)
        }
        inputEmail.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(0).keyboard(false, in: self.view)
        }
        inputEmail.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-100).keyboard(true, in: self.view)
        }

        inputPassword.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(60).keyboard(false, in: self.view)
        }
        inputPassword.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-40).keyboard(true, in: self.view)
        }

        progressPassword.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(5)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(95).keyboard(false, in: self.view)
        }
        progressPassword.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-5).keyboard(true, in: self.view)
        }

        buttonSignup.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(80)
            make.centerY.equalTo(self.view).offset(140).keyboard(false, in: self.view)
        }
        buttonSignup.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(40).keyboard(true, in: self.view)
        }
        buttonSignin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(-80)
            make.centerY.equalTo(self.view).offset(140).keyboard(false, in: self.view)
        }
        buttonSignin.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(40).keyboard(true, in: self.view)
        }
        labelErrors.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(160).keyboard(false, in: self.view)
        }
        labelErrors.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(60).keyboard(true, in: self.view)
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

    func bind(reactor: AuthSignUpReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension AuthSignUpController {

    // MARK: views (View -> View)

    func bindView(_ reactor: AuthSignUpReactor) {
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

    func bindAction(_ reactor: AuthSignUpReactor) {
        // button signin
        buttonSignin.rx.tap
            .map { _ in Reactor.Action.signIn }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // button signup
        buttonSignup.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.signUp }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // form
        Observable.combineLatest([self.inputLastName, self.inputFirstName, self.inputEmail, self.inputPassword].map { $0.rx.text.orEmpty })
            .map { $0.map { $0.isEmpty } }
            .map {Reactor.Action.updateIsFilled(!$0.contains(true))}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        // firstname
        self.inputFirstName.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateFirstName($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputFirstName.rx.controlEvent(.editingChanged).asObservable()
            .debounce(.milliseconds(Metric.timesErrorsDebounce), scheduler: MainScheduler.instance)
            .map {Reactor.Action.validateFirstName}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // lastname
        self.inputLastName.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateLastName($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputLastName.rx.controlEvent(.editingChanged).asObservable()
            .debounce(.milliseconds(Metric.timesErrorsDebounce), scheduler: MainScheduler.instance)
            .map {Reactor.Action.validateLastName}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
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
        self.inputPassword.rx.controlEvent(.editingChanged).asObservable()
            .debounce(.milliseconds(Metric.timesErrorsDebounce), scheduler: MainScheduler.instance)
            .map {Reactor.Action.validatePassword}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputPassword.rx.controlEvent(.editingChanged).asObservable()
            .map {Reactor.Action.validateStrength}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: AuthSignUpReactor) {
        reactor.state
            .map { $0.strength }
            .distinctUntilChanged()
            .subscribe(onNext: { strength in
                switch strength {
                case 3:
                    self.progressPassword.setProgress(0.25, animated: true)
                    self.progressPassword.progressTintColor = UIColor.red.darker(by: 10)
                case 2:
                    self.progressPassword.setProgress(0.5, animated: true)
                    self.progressPassword.progressTintColor = UIColor.orange.darker(by: 10)
                case 1:
                    self.progressPassword.setProgress(0.75, animated: true)
                    self.progressPassword.progressTintColor = UIColor.cyan.darker(by: 10)
                case 0:
                    self.progressPassword.setProgress(1, animated: true)
                    self.progressPassword.progressTintColor = UIColor.green.darker(by: 10)
                default:
                    self.progressPassword.setProgress(0, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
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
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
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
                SwiftMessages.hideAll()
                SwiftMessages.show(config: self.popupConfig, view: self.error)
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.errors.count }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                if reactor.currentState.errors.firstIndex(where: { $0.title == "\(User.Validators.firstname)" }) != nil {
                    self.inputFirstName.layer.borderWidth = 1.0
                } else {
                    self.inputFirstName.layer.borderWidth = 0
                }
                if reactor.currentState.errors.firstIndex(where: { $0.title ==  "\(User.Validators.lastname)" }) != nil {
                    self.inputLastName.layer.borderWidth = 1.0
                } else {
                    self.inputLastName.layer.borderWidth = 0
                }
                if reactor.currentState.errors.firstIndex(where: { $0.title ==  "\(User.Validators.email)" }) != nil {
                    self.inputEmail.layer.borderWidth = 1.0
                } else {
                    self.inputEmail.layer.borderWidth = 0
                }
                if reactor.currentState.errors.firstIndex(where: { $0.title ==  "\(User.Validators.password)" }) != nil {
                    self.inputPassword.layer.borderWidth = 1.0
                } else {
                    self.inputPassword.layer.borderWidth = 0
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
        .bind(to: self.buttonSignup.rx.isEnabled)
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
