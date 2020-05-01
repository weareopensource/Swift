/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class AuthSignInController: CoreController, View, Stepper {

    // MARK: Constants

    struct Metric {
        static let primary = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
    }

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
        $0.setTitleColor(Metric.primary, for: .normal)
    }
    let buttonSignup = CoreUIButton().then {
        $0.setTitle(L10n.authSignUpTitle, for: .normal)
    }
    let labelErrors = CoreUILabel().then {
        $0.numberOfLines = 4
        $0.textAlignment = .center
        $0.textColor = UIColor.red
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
        self.view.registerAutomaticKeyboardConstraints() // active layout with snapkit
        self.view.addSubview(self.inputEmail)
        self.view.addSubview(self.inputPassword)
        self.view.addSubview(self.buttonSignin)
        self.view.addSubview(self.buttonSignup)
        self.view.addSubview(self.labelErrors)
    }

    override func setupConstraints() {
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
        labelErrors.snp.prepareConstraints {  (make) -> Void in
            make.centerY.equalTo(self.view).offset(20).keyboard(true, in: self.view)
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
        // add button
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

    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: AuthSigninReactor) {
        // button signin
        buttonSignin.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.signIn }
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
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
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
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .map {Reactor.Action.validatePassword}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: AuthSigninReactor) {
        // error
        reactor.state
            .map { $0.errors.count }
            .distinctUntilChanged()
            .subscribe(onNext: { count in
                if(count > 0) {
                    let message: [String] = reactor.currentState.errors.map { "\($0.description)." }
                    ToastCenter.default.cancelAll()
                    Toast(text: message.joined(separator: "\n"), delay: 0, duration: Delay.long).show()
                } else {
                    ToastCenter.default.cancelAll()
                }

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
    }
}
