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
    }
    let inputLastName = TextRow {
        $0.title = L10n.userEditLastname
    }
    let inputEmail = EmailRow {
        $0.title = L10n.userEditMail
    }
    let labelErrorsAccount = CoreUILabel().then {
        $0.textAlignment = .left
        $0.textColor = Metric.error
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    // extra
    let inputBio = TextAreaRow {
        $0.placeholder = L10n.userEditBio
        $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
    }
    let labelErrorsProfil = CoreUILabel().then {
        $0.textAlignment = .left
        $0.textColor = Metric.error
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    // avatar
    let imageAvatar = UIImageView()
    let inputAvatar = ImageRow {
        $0.title = L10n.userEditImage
        $0.sourceTypes = .PhotoLibrary
        $0.clearAction = .yes(style: .destructive)
        $0.allowEditor = true
        $0.value = UIImage(named: "AppIcon")
    }
    let imageGravatar = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        $0.layer.cornerRadius = 44/2

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
            +++ Section(header: L10n.userEditSectionAccount, footer: "") { section in
                var footer = HeaderFooterView<UILabel>(.class)
                footer.height = { 30 }
                footer.onSetupView = {view, _ in
                    view.addSubview(self.labelErrorsAccount)
                    self.labelErrorsAccount.snp.makeConstraints { (make) -> Void in
                        make.right.left.equalTo(view).offset(Metric.margin/2)
                        make.top.equalTo(view).offset(Metric.margin)
                    }
                }
                section.footer = footer
            }
            <<< self.inputFirstName
            <<< self.inputLastName
            <<< self.inputEmail

            +++ Section(header: L10n.userEditSectionProfile, footer: "") { section in
                var footer = HeaderFooterView<UILabel>(.class)
                footer.height = { 30 }
                footer.onSetupView = {view, _ in
                    view.addSubview(self.labelErrorsProfil)
                    self.labelErrorsProfil.snp.makeConstraints { (make) -> Void in
                        make.right.left.equalTo(view).offset(Metric.margin/2)
                        make.top.equalTo(view).offset(Metric.margin)
                    }
                }
                section.footer = footer
            }
            <<< self.inputBio

            +++ Section(header: L10n.userEditSectionImage, footer: "")
            <<< self.inputAvatar.cellUpdate { cell, _ in
                cell.accessoryView?.layer.cornerRadius = (cell.accessoryView?.frame.height ?? 20)/2
            }.onChange({ (img) in
                if let aux = img.value {
                    self.avatar.accept(aux.jpegData(compressionQuality: Metric.imgCompression))
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
        let observableFirstName = self.inputFirstName.rx.text.share()
        observableFirstName
            .filterNil()
            .map {Reactor.Action.updateFirstName($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableFirstName
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateFirstName("account")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        let observableLastName = self.inputLastName.rx.text.share()
        observableLastName
            .filterNil()
            .map {Reactor.Action.updateLastName($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableLastName
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateLastName("account")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        let observableEmail = self.inputEmail.rx.text.share()
        observableEmail
            .filterNil()
            .map {Reactor.Action.updateEmail($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableEmail
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateEmail("account")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // extra
        let observableBio = self.inputBio.rx.text.share()
        observableBio
            .skip(1)
            .map {Reactor.Action.updateBio($0 ?? "")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableBio
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateBio("profil")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // avatar
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
            })
            .disposed(by: self.disposeBag)
        // extra
        reactor.state
            .map { $0.user.bio }
            .subscribe(onNext: { bio in
                self.inputBio.value = bio
                self.inputBio.updateCell()
            })
            .disposed(by: self.disposeBag)
        // avatar
        reactor.state
            .take(1)
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .map { $0.user.email }
            .distinctUntilChanged()
            .subscribe(onNext: { email in
                self.imageGravatar.setImage(url: "https://secure.gravatar.com/avatar/\(email.md5)?s=200&d=mp")
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.avatar }
            .distinctUntilChanged()
            .subscribe(onNext: { avatar in
                if (avatar != "") {
                    self.imageAvatar.setImage(url: setUploadImageUrl(avatar, size: "256"), options: [.requestModifier(cookieModifier)]) { result in
                        switch result {
                        case .success(let value):
                            self.inputAvatar.value = value.image
                            self.inputAvatar.updateCell()
                            break
                        case .failure(let error):
                            log.error("🌄 Error -> \(error)")
                            break
                        }
                    }
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
            .map { $0.errors.count }
            .distinctUntilChanged()
            .subscribe(onNext: { count in
                self.labelErrorsAccount.text = reactor.currentState.errors.filter({ $0.type == "account" }).map { $0.description }.joined(separator: ". ")
                self.labelErrorsProfil.text = reactor.currentState.errors.filter({ $0.type == "profil" }).map { $0.description }.joined(separator: ". ")
                if(count > 0 && self.labelErrorsAccount.text?.count == 0 && self.labelErrorsProfil.text?.count == 0) {
                    let message: [String] = reactor.currentState.errors.map { "\($0.description)." }
                    ToastCenter.default.cancelAll()
                    Toast(text: message.joined(separator: "\n"), delay: 0, duration: Delay.long).show()
                }
                if(count > 0) {
                    self.barButtonDone.isEnabled = false
                } else {
                    self.barButtonDone.isEnabled = true
                }
            })
            .disposed(by: self.disposeBag)
    }
}
