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

    // MARK: UI

    let refreshControl = CoreUIRefreshControl()

    let imageAvatar = UIImageView().then {
        $0.contentMode = UIView.ContentMode.scaleAspectFill
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        $0.kf.indicatorType = .activity
        $0.layer.cornerRadius = Metric.avatar/2
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
        $0.setFontAwesomeIcon("fa-user")
    }
    let buttonPreferences = ButtonRow {
        $0.title = L10n.userPreferences
        $0.setFontAwesomeIcon("fa-drafting-compass")
    }

    // buttons App
    let buttonSite = ButtonRow {
        $0.title = L10n.userSite
        $0.setFontAwesomeIcon("fa-external-link-alt", color: Metric.secondary ?? .lightGray, opacity: 1)
    }
    let buttonBlog = ButtonRow {
        $0.title = L10n.userBlog
        $0.setFontAwesomeIcon("fa-rss", color: Metric.secondary ?? .lightGray, opacity: 1)
    }
    let buttonUs = ButtonRow {
        $0.title = L10n.userUs
        $0.setFontAwesomeIcon("fa-user-astronaut")
    }
    let buttonSupport = ButtonRow {
        $0.title = L10n.userSupport
        $0.setFontAwesomeIcon("fa-question")
    }
    let buttonMore = ButtonRow {
        $0.title = L10n.userMore
        $0.setFontAwesomeIcon("fa-ellipsis-h")
    }

    // buttons social Networks
    let buttonInstagram = ButtonRow {
        $0.title = "Instagram"
        $0.setFontAwesomeIcon("fa-instagram", style: .brands, color: Metric.instagram ?? .lightGray, opacity: 1)
    }
    let buttonTwitter = ButtonRow {
        $0.title = "Twitter"
        $0.setFontAwesomeIcon("fa-twitter", style: .brands, color: Metric.twitter ?? .lightGray, opacity: 1)
    }
    let buttonLinkedin = ButtonRow {
        $0.title = "Linkedin"
        $0.setFontAwesomeIcon("fa-linkedin", style: .brands, color: Metric.linkedin ?? .lightGray, opacity: 1)
    }
    let buttonFacebook = ButtonRow {
        $0.title = "Facebook"
        $0.setFontAwesomeIcon("fa-facebook", style: .brands, color: Metric.facebook ?? .lightGray, opacity: 1)
    }

    // buttons Actions
    let buttonReport = ButtonRow {
        $0.title = L10n.userReport
        $0.setFontAwesomeIcon("fa-bug")
    }
    let buttonContact = ButtonRow {
        $0.title = L10n.userContact
        $0.setFontAwesomeIcon("fa-envelope")
    }
    let buttonData = ButtonRow {
        $0.title = L10n.userData
        $0.setFontAwesomeIcon("fa-database")
    }
    let buttonLogout = ButtonRow {
        $0.title = L10n.userLogout
        $0.setFontAwesomeIcon("fa-arrow-left")
    }
    let buttonDelete = ButtonRow {
        $0.title = L10n.userDelete
        $0.setFontAwesomeIcon("fa-trash-alt", color: Metric.error ?? .red, opacity: 1)
    }

    // MARK: Properties

    let application = UIApplication.shared

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
                        make.width.height.equalTo(Metric.avatar)
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
            <<< self.buttonPreferences
            +++ Section(header: L10n.userSectionApp, footer: "")
            <<< self.buttonBlog
            <<< self.buttonSite
            <<< self.buttonUs
            <<< self.buttonSupport
            <<< self.buttonMore
            +++ Section(header: L10n.userSectionSocialnetworks, footer: "")
            <<< self.buttonInstagram
            <<< self.buttonTwitter
            <<< self.buttonLinkedin
            <<< self.buttonFacebook
            +++ Section(header: L10n.userSectionContact, footer: "")
            <<< self.buttonContact
            <<< self.buttonReport
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
        self.buttonPreferences.rx.tap
            .subscribe(onNext: { _ in
                let viewController = UserPreferenceController(reactor: reactor.preferenceReactor())
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
        self.buttonSite.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: (config["app"]["links"]["site"].string ?? "")) else { return }
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
        self.buttonSupport.rx.tap
            .subscribe(onNext: { _ in
                if let url = config["app"]["links"]["support"].string {
                    if (url.prefix(4) == "http") {
                        guard let url = URL(string: url) else { return }
                        let svc = SFSafariViewController(url: url)
                        self.present(svc, animated: true, completion: nil)
                    } else {
                        let viewController = HomePageController(reactor: reactor.pageReactor(name: url))
                        let navigationController = UINavigationController(rootViewController: viewController)
                        self.present(navigationController, animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
        self.buttonMore.rx.tap
            .subscribe(onNext: { _ in
                let viewController = UserMoreController(reactor: reactor.moreReactor())
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        //social networks
        self.buttonInstagram.rx.tap
            .subscribe(onNext: { _ in
                guard let appURL = URL(string: "instagram://user?username=\(config["app"]["links"]["instagram"].string ?? "")") else { return }
                guard let webURL = URL(string: "https://instagram.com/\(config["app"]["links"]["instagram"].string ?? "")") else { return }
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(webURL)
                    }
                }
            })
            .disposed(by: disposeBag)
        self.buttonTwitter.rx.tap
            .subscribe(onNext: { _ in
                guard let appURL = URL(string: "twitter://user?screen_name=\(config["app"]["links"]["twitter"].string ?? "")") else { return }
                guard let webURL = URL(string: "https://twitter.com/\(config["app"]["links"]["twitter"].string ?? "")") else { return }
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(webURL)
                    }
                }
            })
            .disposed(by: disposeBag)
        self.buttonLinkedin.rx.tap
            .subscribe(onNext: { _ in
                guard let appURL = URL(string: "linkedin://company/\(config["app"]["links"]["linkedin"].string ?? "")") else { return }
                guard let webURL = URL(string: "https://linkedin.com/company/\(config["app"]["links"]["linkedin"].string ?? "")") else { return }
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(webURL)
                    }
                }
            })
            .disposed(by: disposeBag)
        self.buttonFacebook.rx.tap
            .subscribe(onNext: { _ in
                guard let appURL = URL(string: "fb://profile/\(config["app"]["links"]["facebook"].string ?? "")") else { return }
                guard let webURL = URL(string: "https://www.facebook.com/\(config["app"]["links"]["facebook"].string ?? "")") else { return }
                if UIApplication.shared.canOpenURL(appURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(appURL)
                    }
                } else {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(webURL)
                    }
                }
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
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
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
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
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
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
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
                }
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.avatar }
            .distinctUntilChanged()
            .subscribe(onNext: { avatar in
                if (avatar != "") {
                    self.imageAvatar.setImage(url: setUploadImageUrl(avatar, size: "256"), options: [.requestModifier(cookieModifier)])
                } else {
                    self.imageAvatar.setImage(url: "https://secure.gravatar.com/avatar/\(reactor.currentState.user.email.md5)?s=200&d=mp")
                }
            })
            .disposed(by: self.disposeBag)
        // social networks
        reactor.state
            .map { $0.configuration }
            .subscribe(onNext: { configuration in
                if(configuration["app"]["links"]["instagram"].string == "") {
                    self.buttonInstagram.hidden = true
                    self.buttonInstagram.evaluateHidden()
                }
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.configuration }
            .subscribe(onNext: { configuration in
                if(configuration["app"]["links"]["twitter"].string == "") {
                    self.buttonTwitter.hidden = true
                    self.buttonTwitter.evaluateHidden()
                }
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.configuration }
            .subscribe(onNext: { configuration in
                if(configuration["app"]["links"]["linkedin"].string == "") {
                    self.buttonLinkedin.hidden = true
                    self.buttonLinkedin.evaluateHidden()
                }
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.configuration }
            .subscribe(onNext: { configuration in
                if(configuration["app"]["links"]["facebook"].string == "") {
                    self.buttonFacebook.hidden = true
                    self.buttonFacebook.evaluateHidden()
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
            .bind(to: self.labelEmail.rx.text)
            .disposed(by: self.disposeBag)
        // refreshing
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

/**
 * Extension
 */

extension UserController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
