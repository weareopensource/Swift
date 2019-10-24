/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class AuthSignUpController: CoreController, View, Stepper {

    // MARK: UI
    let inputFirstName = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.placeholder = L10n.authFirstname + "..."
    }
    let inputLastName = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.placeholder = L10n.authLastname + "..."
    }
    let inputEmail = CoreUITextField().then {
        $0.autocorrectionType = .no
        $0.placeholder = L10n.authMail + "..."
        $0.autocapitalizationType = .none
        $0.textContentType = .username
    }
    let inputPassword = CoreUITextField().then {
        $0.autocorrectionType = .no
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
            .map { _ in Reactor.Action.signUp }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // firstname
        self.inputFirstName.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateFirstName($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputFirstName.rx.controlEvent(.editingDidEnd).asObservable()
            .map {Reactor.Action.validateFirstName}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // lastname
        self.inputLastName.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateLastName($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputLastName.rx.controlEvent(.editingDidEnd).asObservable()
            .map {Reactor.Action.validateLastName}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // email
        self.inputEmail.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateEmail($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputEmail.rx.controlEvent(.editingDidEnd).asObservable()
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

    func bindState(_ reactor: AuthSignUpReactor) {
        // dissmissed
        reactor.state
            .map { $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // errors
        reactor.state
            .map { $0.error?.description }
            .distinctUntilChanged()
            .bind(to: self.labelErrors.rx.text)
            .disposed(by: self.disposeBag)
    }
}
