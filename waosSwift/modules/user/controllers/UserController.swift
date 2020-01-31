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

    // buttons link
    let buttonHelp = ButtonRow {
        $0.title = L10n.userHelp
    }
    let buttonTermsOfService = ButtonRow {
        $0.title = L10n.userTermsOfService
    }
    let buttonPrivacyPolicy = ButtonRow {
        $0.title = L10n.userPrivacyPolicy
    }
    let buttonAbout = ButtonRow {
        $0.title = L10n.userAbout
    }

    // buttons action
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
                header.height = { 100.0 }
                header.onSetupView = {view, _ in
                    view.addSubview(self.labelName)
                    view.addSubview(self.labelEmail)
                    self.labelName.snp.makeConstraints { (make) -> Void in
                        make.centerX.equalTo(view)
                        make.centerY.equalTo(view).offset(-15)
                    }
                    self.labelEmail.snp.makeConstraints { (make) -> Void in
                        make.centerX.equalTo(view)
                        make.centerY.equalTo(view).offset(15)
                    }
                }
                section.header = header
            }
            <<< self.buttonProfil
            +++ Section(header: L10n.userSectionApp, footer: "")
            <<< self.buttonHelp
            <<< self.buttonTermsOfService
            <<< self.buttonPrivacyPolicy
            <<< self.buttonAbout
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
        self.buttonHelp.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://google.com") else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonTermsOfService.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://apple.com") else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonPrivacyPolicy.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://weareopensource.me") else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonAbout.rx.tap
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://google.com") else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonReport.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["contact"].string ?? "")])
                    mvc.setSubject(L10n.userReport)
                    self.present(mvc, animated: true)
                } else {
                    Toast(text: L10n.userErrorMail, delay: 0, duration: Delay.long).show()
                }
            })
            .disposed(by: disposeBag)
        self.buttonContact.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["contact"].string ?? "")])
                    mvc.setSubject(L10n.userContact)
                    self.present(mvc, animated: true)
                } else {
                    Toast(text: L10n.userErrorMail, delay: 0, duration: Delay.long).show()
                }
            })
            .disposed(by: disposeBag)
        self.buttonData.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["contact"].string ?? "")])
                    mvc.setSubject(L10n.userData)
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
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: UserReactor) {
        // to update button content in eureka -> self.buttonProfil.updateCell()
        // labels
        reactor.state
            .map { $0.user.firstName }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.labelName.text = "\(reactor.currentState.user.firstName) \(reactor.currentState.user.lastName)"
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.lastName }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.labelName.text = "\(reactor.currentState.user.firstName) \(reactor.currentState.user.lastName)"
            })
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.user.email }
            .distinctUntilChanged()
            .subscribe(onNext: { _ in
                self.labelEmail.text = "\(reactor.currentState.user.email)"
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
