/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class AuthSignUpController: CoreController, View, Stepper, NVActivityIndicatorViewable {

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
        self.view.registerAutomaticKeyboardConstraints() // active layout with snapkit
        self.view.addSubview(self.inputFirstName)
        self.view.addSubview(self.inputLastName)
        self.view.addSubview(self.inputEmail)
        self.view.addSubview(self.inputPassword)
        self.view.addSubview(self.buttonSignin)
        self.view.addSubview(self.buttonSignup)
        self.view.addSubview(self.labelErrors)
    }

    override func setupConstraints() {
        inputFirstName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-140).keyboard(false, in: self.view)
        }
        inputFirstName.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-240).keyboard(true, in: self.view)
        }
        inputLastName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-80).keyboard(false, in: self.view)
        }
        inputLastName.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-180).keyboard(true, in: self.view)
        }
        inputEmail.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-20).keyboard(false, in: self.view)
        }
        inputEmail.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-120).keyboard(true, in: self.view)
        }
        inputPassword.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(40).keyboard(false, in: self.view)
        }
        inputPassword.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(-60).keyboard(true, in: self.view)
        }
        buttonSignup.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(80)
            make.centerY.equalTo(self.view).offset(100).keyboard(false, in: self.view)
        }
        buttonSignup.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(0).keyboard(true, in: self.view)
        }
        buttonSignin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view).offset(-80)
            make.centerY.equalTo(self.view).offset(100).keyboard(false, in: self.view)
        }
        buttonSignin.snp.prepareConstraints { (make) -> Void in
            make.centerY.equalTo(self.view).offset(0).keyboard(true, in: self.view)
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
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: AuthSignUpReactor) {
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
                ToastCenter.default.cancelAll()
                Toast(text: errors.map { "\($0.description)." }.joined(separator: "\n"), delay: 0, duration: Delay.long).show()
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
    }
}
