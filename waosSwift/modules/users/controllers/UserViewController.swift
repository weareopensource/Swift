/**
 * Dependencies
 */

import UIKit
import ReactorKit
import Eureka
import SafariServices
import ImageRow
import RxRelay
import SwiftMessages
import MessageUI

/**
 * Controller
 */

class UserViewController: CoreFormController, View {

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

    // social networks
    let inputInstagram = TextRow {
        $0.placeholder = L10n.userEditSocialnetworksInstagram
        $0.setFontAwesomeIcon("fa-instagram", style: .brands, color: Metric.instagram ?? .lightGray, opacity: 1)
    }
    let inputTwitter = TextRow {
        $0.placeholder = L10n.userEditSocialnetworksTwitter
        $0.setFontAwesomeIcon("fa-twitter", style: .brands, color: Metric.twitter ?? .lightGray, opacity: 1)
    }
    let inputFacebook = TextRow {
        $0.placeholder = L10n.userEditSocialnetworksFacebook
        $0.setFontAwesomeIcon("fa-facebook", style: .brands, color: Metric.facebook ?? .lightGray, opacity: 1)
    }
    let labelErrorsSocialNetworks = CoreUILabel().then {
        $0.textAlignment = .left
        $0.textColor = Metric.error
        $0.font = UIFont.systemFont(ofSize: 13)
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
            // Account
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
            // Profile
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
            // Avatar
            +++ Section(header: L10n.userEditSectionImage, footer: "")
            <<< self.inputAvatar.cellUpdate { cell, _ in
                cell.accessoryView?.layer.cornerRadius = (cell.accessoryView?.frame.height ?? 20)/2
            }.onChange({ (img) in
                if let aux = img.value?.adjustOrientation()?.resizeImage(targetSize: CGSize(width: Metric.imgMax, height: Metric.imgMax)) {
                    self.avatar.accept(aux.jpegData(compressionQuality: Metric.imgCompression))
                } else {
                    self.avatar.accept(nil)
                }
            })
            <<< self.buttonImageGravatar.cellUpdate { cell, _ in
                cell.accessoryView = self.imageGravatar
            }
            // Social Networks
            +++ Section(header: L10n.userEditSectionSocialnetworks, footer: "") { section in
                var footer = HeaderFooterView<UILabel>(.class)
                footer.height = { 30 }
                footer.onSetupView = {view, _ in
                    view.addSubview(self.labelErrorsSocialNetworks)
                    self.labelErrorsSocialNetworks.snp.makeConstraints { (make) -> Void in
                        make.right.left.equalTo(view).offset(Metric.margin/2)
                        make.top.equalTo(view).offset(Metric.margin)
                    }
                }
                section.footer = footer
            }
            <<< self.inputInstagram
            <<< self.inputTwitter
            <<< self.inputFacebook

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

    func bindAction(_ reactor: UserViewReactor) {
        // buttons
        self.barButtonDone.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // inputs
        let observableFirstName = self.inputFirstName.rx.text.share()
        observableFirstName
            .skip(1)
            .map {Reactor.Action.updateFirstName($0 ?? "")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableFirstName
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateFirstName("account")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        let observableLastName = self.inputLastName.rx.text.share()
        observableLastName
            .skip(1)
            .map {Reactor.Action.updateLastName($0 ?? "")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableLastName
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateLastName("account")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        let observableEmail = self.inputEmail.rx.text.share()
        observableEmail
            .skip(1)
            .map {Reactor.Action.updateEmail($0 ?? "")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableEmail
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
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
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
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
            .filter { $0 == nil && reactor.currentState.user.avatar != "" }
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.deleteAvatar }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // social networks
        let observableInstagram = self.inputInstagram.rx.text.share()
        observableInstagram
            .skip(1)
            .map {Reactor.Action.updateInstagram($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableInstagram
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateInstagram("socialnetworks")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        let observableTwitter = self.inputTwitter.rx.text.share()
        observableTwitter
            .skip(1)
            .map {Reactor.Action.updateTwitter($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableTwitter
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateTwitter("socialnetworks")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        let observableFacebook = self.inputFacebook.rx.text.share()
        observableFacebook
            .skip(1)
            .map {Reactor.Action.updateFacebook($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        observableFacebook
            .debounce(.milliseconds(Metric.timesErrorsShort), scheduler: MainScheduler.instance)
            .map {_ in Reactor.Action.validateFacebook("socialnetworks")}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: UserViewReactor) {
        // inputs
        reactor.state
            .map { $0.user.firstName }
            .take(1)
            .subscribe(onNext: { firstName in
                self.inputFirstName.value = firstName
                self.inputFirstName.updateCell()
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.lastName }
            .take(1)
            .subscribe(onNext: { lastName in
                self.inputLastName.value = lastName
                self.inputLastName.updateCell()
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.email }
            .take(1)
            .subscribe(onNext: { email in
                self.inputEmail.value = email
                self.inputEmail.updateCell()
            })
            .disposed(by: self.disposeBag)
        // extra
        reactor.state
            .map { $0.user.bio }
            .filterNil()
            .take(1)
            .subscribe(onNext: { bio in
                self.inputBio.value = bio
                self.inputBio.updateCell()
            })
            .disposed(by: self.disposeBag)
        // avatar
        reactor.state
            .take(1)
            .debounce(.milliseconds(Metric.timesErrorsDebounce), scheduler: MainScheduler.instance)
            .map { $0.user.email }
            .distinctUntilChanged()
            .subscribe(onNext: { email in
                self.imageGravatar.setImage(url: "https://secure.gravatar.com/avatar/\(email.md5)?s=200&d=mp")
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.avatar }
            .take(1)
            .subscribe(onNext: { avatar in
                if (avatar != "") {
                    self.imageAvatar.setImage(url: setUploadImageUrl(avatar, sizes: [256]), options: [.requestModifier(cookieModifier)], completionHandler: { result in
                        switch result {
                        case .success(let value):
                            self.inputAvatar.value = value.image
                            self.inputAvatar.updateCell()
                            break
                        case .failure(let error):
                            log.error("🌄 Error -> \(error)")
                            break
                        }
                    })
                }
            })
            .disposed(by: self.disposeBag)
        // social networks
        reactor.state
            .map { $0.user.complementary?.socialNetworks?.instagram }
            .filterNil()
            .take(1)
            .subscribe(onNext: { instagram in
                self.inputInstagram.value = instagram
                self.inputInstagram.updateCell()
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.complementary?.socialNetworks?.twitter }
            .filterNil()
            .take(1)
            .subscribe(onNext: { twitter in
                self.inputTwitter.value = twitter
                self.inputTwitter.updateCell()
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.complementary?.socialNetworks?.facebook }
            .filterNil()
            .take(1)
            .subscribe(onNext: { facebook in
                self.inputFacebook.value = facebook
                self.inputFacebook.updateCell()
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
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // validation errors
        reactor.state
            .map { $0.errors }
            .distinctUntilChanged { $0.count == $1.count }
            .subscribe(onNext: { errors in
                self.labelErrorsAccount.text = errors.filter({ $0.type == "account" }).map { $0.description }.joined(separator: ". ")
                self.labelErrorsProfil.text = errors.filter({ $0.type == "profil" }).map { $0.description }.joined(separator: ". ")
                if(errors.count > 0 && self.labelErrorsAccount.text?.count == 0 && self.labelErrorsProfil.text?.count == 0) {
                    let message: [String] = errors.map { "\($0.description)." }
                    self.error.configureContent(title: "Schema", body: message.joined(separator: "\n"))

                }
                self.barButtonDone.isEnabled = errors.count > 0 ? false : true
            })
            .disposed(by: self.disposeBag)
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
