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

    let inputEmail = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "email..."
        $0.autocapitalizationType = .none
        $0.textContentType = .username
    }
    let inputPassword = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "password..."
        $0.autocapitalizationType = .none
        $0.returnKeyType = .done
        $0.isSecureTextEntry = true
        $0.textContentType = .password
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
    let labelErrors = UILabel().then {
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
        self.view.backgroundColor = .white
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
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)

    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: AuthSigninReactor) {
        // button signin
        buttonSignin.rx.tap
            .map { _ in Reactor.Action.signIn }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // email
        self.inputEmail.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .map {Reactor.Action.validateEmail}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputEmail.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateEmail($0!)}
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
        // errors
        reactor.state
            .map { $0.error?.description }
            .distinctUntilChanged()
            .bind(to: self.labelErrors.rx.text)
            .disposed(by: self.disposeBag)
    }
}
