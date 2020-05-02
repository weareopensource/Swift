/**
 * Dependencies
 */

import UIKit
import ReactorKit
import Eureka
import SafariServices
import MessageUI
import ImageRow

/**
 * Controller
 */

class UserViewController: CoreFormController, View, NVActivityIndicatorViewable {

    // MARK: Constant

    fileprivate var avatar = BehaviorRelay<Data?>(value: nil)

    // MARK: UI

    let barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let barButtonDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)

    // inputs
    let inputFirstName = TextRow {
        $0.title = L10n.userEditFirstname
        $0.validationOptions = .validatesOnDemand
    }
    let inputLastName = TextRow {
        $0.title = L10n.userEditLastname
        $0.validationOptions = .validatesOnDemand
    }
    let inputEmail = EmailRow {
        $0.title = L10n.userEditMail
        $0.validationOptions = .validatesOnDemand
    }

    let imageAvatar = UIImageView()
    let inputAvatar = ImageRow {
        $0.title = L10n.userEditImage
        $0.sourceTypes = .PhotoLibrary
        $0.clearAction = .yes(style: .destructive)
        $0.allowEditor = true
    }

    let imageGravatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)).then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "AppIcon")
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
    }
    let buttonImageGravatar = ButtonRow {
        $0.title = L10n.userEditImageGravatar
    }

    // MARK: Initializing

    init(reactor: UserViewReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        form
            +++ Section(header: L10n.userEditSection, footer: "")
            <<< self.inputFirstName
            <<< self.inputLastName
            <<< self.inputEmail
            +++ Section(header: L10n.userEditSectionImage, footer: "")
            <<< self.inputAvatar.cellUpdate { cell, _ in
                cell.accessoryView?.layer.cornerRadius = (cell.accessoryView?.frame.height ?? 20)/2
            }.onChange({ (img) in
                if let aux = img.value {
                    self.avatar.accept(aux.pngData())
                } else {
                    self.avatar.accept(nil)
                }
            })
            <<< self.buttonImageGravatar.cellUpdate { cell, _ in
                cell.accessoryView = self.imageGravatar
            }

        self.navigationItem.leftBarButtonItem = self.barButtonCancel
        self.navigationItem.rightBarButtonItem = self.barButtonDone
        self.view.addSubview(self.tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Binding

    func bind(reactor: UserViewReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }

}

/**
 * Extensions
 */

private extension UserViewController {

    // MARK: views (View -> View)

    func bindView(_ reactor: UserViewReactor) {
        // cancel
        self.barButtonCancel.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: UserViewReactor) {
        // buttons
        self.barButtonDone.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // inputs
        self.inputFirstName.rx.text
            .filterNil()
            .asObservable()
            .map {Reactor.Action.updateFirstName($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputFirstName.rx.isHighlighted
            .asObservable()
            .subscribe(onNext: { result in
                if (!result) {
                    self.inputFirstName.remove(ruleWithIdentifier: "firstname")
                    self.inputFirstName.add(rule: RuleUserEurekaToValidator(reactor.currentState.user, User.Validators.firstname, "firstname"))
                    self.inputFirstName.validate()
                    self.form.mergeErrorToFooter()
                }
            })
            .disposed(by: self.disposeBag)
        self.inputLastName.rx.text
            .filterNil()
            .asObservable()
            .map {Reactor.Action.updateLastName($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputLastName.rx.isHighlighted
            .asObservable()
            .subscribe(onNext: { result in
                if (!result) {
                    self.inputLastName.remove(ruleWithIdentifier: "lastname")
                    self.inputLastName.add(rule: RuleUserEurekaToValidator(reactor.currentState.user, User.Validators.lastname, "lastname"))
                    self.inputLastName.validate()
                    self.form.mergeErrorToFooter()
                }
            })
            .disposed(by: self.disposeBag)
        self.inputEmail.rx.text
            .filterNil()
            .map {Reactor.Action.updateEmail($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.inputEmail.rx.isHighlighted
            .asObservable()
            .subscribe(onNext: { result in
                if (!result) {
                    self.inputEmail.remove(ruleWithIdentifier: "email")
                    self.inputEmail.add(rule: RuleUserEurekaToValidator(reactor.currentState.user, User.Validators.email, "email"))
                    self.inputEmail.validate()
                    self.form.mergeErrorToFooter()
                }
            })
            .disposed(by: self.disposeBag)
        self.buttonImageGravatar.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["gravatar"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.avatar
            .skip(1)
            .filterNil()
            .map {Reactor.Action.updateAvatar($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.avatar
            .skip(1)
            .filter { $0 == nil }
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.deleteAvatar }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: UserViewReactor) {
        // inputs
        reactor.state
            .map { $0.user.firstName }
            .distinctUntilChanged()
            .subscribe(onNext: { firstName in
                self.inputFirstName.value = firstName
                self.inputFirstName.updateCell()
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.lastName }
            .distinctUntilChanged()
            .subscribe(onNext: { lastName in
                self.inputLastName.value = lastName
                self.inputLastName.updateCell()
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.email }
            .distinctUntilChanged()
            .subscribe(onNext: { email in
                self.inputEmail.value = email
                self.inputEmail.updateCell()
                self.imageGravatar.setImage(url: "https://secure.gravatar.com/avatar/\(email.md5)?s=200&d=mp")
                self.imageGravatar.layer.cornerRadius = self.imageGravatar.frame.height/2
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.avatar }
            .distinctUntilChanged()
            .subscribe(onNext: { avatar in
                if (avatar != "") {
                    self.imageAvatar.setImage(url: setUploadImageUrl(avatar, size: "256"), options: [.requestModifier(cookieModifier)])
                    self.inputAvatar.value = self.imageAvatar.image
                    self.inputAvatar.updateCell()
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
        // error
        reactor.state
            .map { $0.error?.description }
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .filterNil()
            .subscribe(onNext: { result in
                Toast(text: result, delay: 0, duration: Delay.long).show()
            })
            .disposed(by: self.disposeBag)
    }
}

/**
 * Struct
 */

public struct RuleUserEurekaToValidator: RuleType {

    let _user: User
    let _validator: User.Validators

    public var id: String?
    public var validationError: Eureka.ValidationError

    init(_ user: User, _ validator: User.Validators, _ id: String, msg: String? = nil) {
        let ruleMsg = msg ?? "Field value must have less than \(validator) characters"
        validationError = ValidationError(msg: ruleMsg)
        _user = user
        _validator = validator
        self.id = id
    }

    public func isValid(value: String?) -> Eureka.ValidationError? {
        guard let value = value, !value.isEmpty else { return nil }
        switch _user.validate(_validator) {
        case .valid: return nil
        case let .invalid(err):
            let description = (err[0] as! CustomError).description ?? "Unknown error"
            return ValidationError(msg: description)
        }
    }
}
