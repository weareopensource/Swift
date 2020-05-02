/**
 * Dependencies
 */

import UIKit
import ReactorKit
import Eureka
import SafariServices
import MessageUI

/**
 * Controller
 */

class UserController: CoreFormController, View {

    // MARK: Constants

    struct Metric {
        static let margin = CGFloat(config["theme"]["global"]["margin"].int ?? 0)
        static let radius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
    }

    // MARK: UI

    let refreshControl = CoreUIRefreshControl()

    let imageAvatar = UIImageView().then {
        $0.contentMode = UIView.ContentMode.scaleAspectFill
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        $0.kf.indicatorType = .activity
    }
    let labelName = CoreUILabel().then {
        $0.textAlignment = .center
    }
    let labelEmail = CoreUILabel().then {
        $0.textAlignment = .center
        $0.textColor = .gray
    }

    // buttons profil
    let buttonProfil = ButtonRow {
        $0.title = L10n.userEdit
    }

    // buttons App
    let buttonBlog = ButtonRow {
        $0.title = L10n.userBlog
        $0.cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }
    let buttonAbout = ButtonRow {
        $0.title = L10n.userAbout
    }
    let buttonUs = ButtonRow {
        $0.title = L10n.userUs
    }

    // button Information
    let buttonHelp = ButtonRow {
        $0.title = L10n.userHelp
    }
    let buttonTermsOfService = ButtonRow {
        $0.title = L10n.userTermsOfService
    }
    let buttonPrivacyPolicy = ButtonRow {
        $0.title = L10n.userPrivacyPolicy
    }

    // buttons Actions
    let buttonReport = ButtonRow {
        $0.title = L10n.userReport
    }
    let buttonContact = ButtonRow {
        $0.title = L10n.userContact
    }
    let buttonData = ButtonRow {
        $0.title = L10n.userData
    }
    let buttonLogout = ButtonRow {
        $0.title = L10n.userLogout
    }
    let buttonDelete = ButtonRow {
        $0.title = L10n.userDelete
    }

    // MARK: Initializing

    init(reactor: UserReactor) {
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
            +++ Section { section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { 175 }
                header.onSetupView = {view, _ in
                    view.addSubview(self.imageAvatar)
                    view.addSubview(self.labelName)
                    view.addSubview(self.labelEmail)
                    self.imageAvatar.snp.makeConstraints { (make) -> Void in
                        make.width.height.equalTo(100)
                        make.centerX.equalTo(view)
                        make.top.equalTo(view).offset(Metric.margin)
                    }
                    self.labelName.snp.makeConstraints { (make) -> Void in
                        make.centerX.equalTo(view)
                        make.top.equalTo(self.imageAvatar.snp.bottom).offset(Metric.margin/2)
                    }
                    self.labelEmail.snp.makeConstraints { (make) -> Void in
                        make.centerX.equalTo(view)
                        make.top.equalTo(self.labelName.snp.bottom)
                    }
                }
                section.header = header
            }
            <<< self.buttonProfil
            +++ Section(header: L10n.userSectionApp, footer: "")
            <<< self.buttonBlog
            <<< self.buttonAbout
            <<< self.buttonUs
            +++ Section(header: L10n.userSectionInformation, footer: "")
            <<< self.buttonHelp
            <<< self.buttonTermsOfService
            <<< self.buttonPrivacyPolicy
            +++ Section(header: L10n.userSectionContact, footer: "")
            <<< self.buttonReport
            <<< self.buttonContact
            <<< self.buttonData
            +++ Section(header: L10n.userSectionActions, footer: "")
            <<< self.buttonLogout
            <<< self.buttonDelete

        self.tableView.refreshControl = refreshControl
        self.tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height), animated: true)
        self.view.addSubview(self.tableView)
    }

    // MARK: Binding

    func bind(reactor: UserReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }

}

/**
 * Extensions
 */

private extension UserController {

    // MARK: views (View -> View)

    func bindView(_ reactor: UserReactor) {
        // buttons
        self.buttonProfil.rx.tap
            .subscribe(onNext: { _ in
                let viewController = UserViewController(reactor: reactor.editReactor(reactor.currentState.user))
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        // app
        self.buttonBlog.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["blog"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonAbout.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["about"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonUs.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["us"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        // informations
        self.buttonHelp.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["help"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonTermsOfService.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["termsOfService"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonPrivacyPolicy.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["privacyPolicy"].string ?? "")) else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        // contact
        self.buttonContact.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["mails"]["contact"].string ?? "")])
                    mvc.setSubject(L10n.userContact)
                    self.present(mvc, animated: true)
                } else {
                    Toast(text: L10n.userErrorMail, delay: 0, duration: Delay.long).show()
                }
            })
            .disposed(by: disposeBag)
        self.buttonReport.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["mails"]["report"].string ?? "")])
                    mvc.setSubject(L10n.userReport)
                    self.present(mvc, animated: true)
                } else {
                    Toast(text: L10n.userErrorMail, delay: 0, duration: Delay.long).show()
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: UserReactor) {
        // viewDidLoad
        self.rx.viewDidLoad
            .map { Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // refresh
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // buttons
        self.buttonData.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let actions: [AlertAction] = [AlertAction.action(title: L10n.modalConfirmationCancel, style: .cancel), AlertAction.action(title: L10n.modalConfirmationOk, style: .default)]
                self.showAlert(title: L10n.userData, message: L10n.userModalConfirmationDataMessage, style: .alert, actions: actions)
                    .filter { $0 == 1 }
                    .map { _ in Reactor.Action.data }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        self.buttonLogout.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let actions: [AlertAction] = [AlertAction.action(title: L10n.modalConfirmationCancel, style: .cancel), AlertAction.action(title: L10n.modalConfirmationOk, style: .destructive)]
                self.showAlert(title: L10n.userLogout, message: L10n.modalConfirmationMessage, style: .alert, actions: actions)
                    .filter { $0 == 1 }
                    .map { _ in Reactor.Action.logout }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
        self.buttonDelete.rx.tap
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let actions: [AlertAction] = [AlertAction.action(title: L10n.modalConfirmationCancel, style: .cancel), AlertAction.action(title: L10n.modalConfirmationOk, style: .destructive)]
                self.showAlert(title: L10n.userDelete, message: L10n.userModalConfirmationDeleteMessage, style: .alert, actions: actions)
                    .filter { $0 == 1 }
                    .map { _ in Reactor.Action.delete }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: UserReactor) {
        // to update button content in eureka -> self.buttonProfil.updateCell()
        // image
        reactor.state
            .map { $0.user.email }
            .distinctUntilChanged()
            .subscribe(onNext: { email in
                if (reactor.currentState.user.avatar == "") {
                    self.imageAvatar.setImage(url: "https://secure.gravatar.com/avatar/\(email.md5)?s=200&d=mp")
                    self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
                }
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.avatar }
            .distinctUntilChanged()
            .subscribe(onNext: { avatar in
                if (avatar != "") {
                    self.imageAvatar.setImage(url: setUploadImageUrl(avatar, size: "256"), options: [.requestModifier(cookieModifier)])
                    self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
                } else {
                    self.imageAvatar.setImage(url: "https://secure.gravatar.com/avatar/\(reactor.currentState.user.email.md5)?s=200&d=mp")
                    self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.height/2
                }
            })
            .disposed(by: self.disposeBag)
        // labels
        reactor.state
            .map { $0.user.firstName }
            .distinctUntilChanged()
            .subscribe(onNext: { firstName in
                self.labelName.text = "\(firstName) \(reactor.currentState.user.lastName)"
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.lastName }
            .distinctUntilChanged()
            .subscribe(onNext: { lastName in
                self.labelName.text = "\(reactor.currentState.user.firstName) \(lastName)"
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.email }
            .distinctUntilChanged()
            .subscribe(onNext: { email in
                self.labelEmail.text = "\(email)"
            })
            .disposed(by: self.disposeBag)
        // refreshing
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
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
 * Extension
 */

extension UserController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
