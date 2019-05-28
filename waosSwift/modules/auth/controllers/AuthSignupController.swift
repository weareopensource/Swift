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
    let inputFirstName = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "firstname..."
        $0.text = "Steve"
    }
    let inputLastName = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "lastname..."
        $0.text = "Jobs"
    }
    let inputEmail = UITextField().then {
        $0.autocorrectionType = .no
        $0.borderStyle = .roundedRect
        $0.placeholder = "email..."
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
        $0.text = "Toto@2019&"
    }
    let buttonSignin = UIButton().then {
        $0.setTitle("Sign In", for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.lightGray
        $0.tintColor = UIColor.lightGray
    }
    let buttonSignup = UIButton().then {
        $0.setTitle("Sign Up", for: .normal)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor.gray
        $0.tintColor = UIColor.gray
    }
    let labelErrors = UILabel().then {
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
        self.view.backgroundColor = .white
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
            make.centerY.equalTo(self.view).offset(-225)
            make.centerX.equalTo(self.view)
        }
        inputLastName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view).offset(-150)
            make.centerX.equalTo(self.view)
        }
        inputEmail.snp.makeConstraints { (make) -> Void in
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
            make.centerX.equalTo(self.view).offset(80)
        }
        buttonSignin.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(140)
            make.height.equalTo(50)
            make.centerY.equalTo(self.view).offset(75)
            make.centerX.equalTo(self.view).offset(-80)
        }
        labelErrors.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(175)
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
        // lastname
        self.inputLastName.rx.text
            .filter { ($0?.count)! > 0 }
            .map {Reactor.Action.updateLastName($0!)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // email
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
            .map { $0.error.description }
            .distinctUntilChanged()
            .bind(to: self.labelErrors.rx.text)
            .disposed(by: self.disposeBag)
    }
}
