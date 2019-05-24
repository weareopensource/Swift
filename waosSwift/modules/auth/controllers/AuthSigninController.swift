/**
 * Dependencies
 */

import UIKit
import ReactorKit

/**
 * Controller
 */

final class AuthSignInController: CoreController, View, Stepper {

    // MARK: UI

    let inputLogin = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "login..."
        $0.autocapitalizationType = .none
        $0.text = "user@localhost.com"
    }
    let inputPassword = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "password..."
        $0.autocapitalizationType = .none
        $0.returnKeyType = .done
        $0.isSecureTextEntry = true
        $0.text = "2MW2EVdCP4F2gdmnVrTPxVkCBKCQwCavH5aF"
    }
    let buttonSignin = UIButton().then {
        $0.setTitle("Sign In", for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.gray
        $0.tintColor = UIColor.lightGray
    }
    let buttonSignup = UIButton().then {
        $0.setTitle("Sign Up", for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.lightGray
        $0.tintColor = UIColor.gray
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
        self.view.backgroundColor = .white
        self.view.addSubview(self.inputLogin)
        self.view.addSubview(self.inputPassword)
        self.view.addSubview(self.buttonSignin)
        self.view.addSubview(self.buttonSignup)
    }

    override func setupConstraints() {
        inputLogin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view).offset(-75)
            make.centerX.equalTo(self.view)
        }
        inputPassword.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view).offset(0)
            make.centerX.equalTo(self.view)
        }
        buttonSignup.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view).offset(75)
            make.centerX.equalTo(self.view).offset(-80)
        }
        buttonSignin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view).offset(75)
            make.centerX.equalTo(self.view).offset(80)
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

    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: AuthSigninReactor) {
        buttonSignin.rx.tap
            .map { _ in Reactor.Action.signIn }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)

        buttonSignup.rx.tap
            .map { _ in Reactor.Action.signUp }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: AuthSigninReactor) {
        // dissmiss
        reactor.state
            .map { $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.steps.accept(Steps.authIsComplete)
            })
            .disposed(by: self.disposeBag)
        // login
        self.inputLogin.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateLogin($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // password
        self.inputPassword.rx.text
            .filter {($0?.count)! > 0}
            .map {Reactor.Action.updatePassword($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
