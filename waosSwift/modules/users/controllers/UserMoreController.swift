/**
 * Dependencies
 */

import UIKit
import RxRelay
import ReactorKit
import Eureka
import SafariServices
import MessageUI
import SwiftMessages

/**
 * Controller
 */

class UserMoreController: CoreFormController, View {

    // MARK: Constant

    fileprivate var avatar = BehaviorRelay<Data?>(value: nil)

    // MARK: UI

    let barButtonClose = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)

    // button Information
    let buttonChangelog = ButtonRow {
        $0.title = "Changelog"
        $0.setFontAwesomeIcon("fa-file")
    }
    let buttonTermsOfUse = ButtonRow {
        $0.title = L10n.userTermsOfUse
        $0.setFontAwesomeIcon("fa-file-alt")
    }
    let buttonPrivacyPolicy = ButtonRow {
        $0.title = L10n.userPrivacyPolicy
        $0.setFontAwesomeIcon("fa-lock")
    }
    let buttonLegalNotice = ButtonRow {
        $0.title = L10n.userLegalNotice
        $0.setFontAwesomeIcon("fa-stamp")
    }

    // MARK: Initializing

    init(reactor: UserMoreReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.standardAppearance = self.transparentNavigationBar
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.transparentNavigationBar
        
        form
            +++ Section(header: L10n.userSectionAbout, footer: "")
            <<< self.buttonChangelog
            <<< self.buttonTermsOfUse
            <<< self.buttonPrivacyPolicy
            <<< self.buttonLegalNotice

        self.navigationController?.clear()
        self.navigationItem.rightBarButtonItem = self.barButtonClose
        self.view.addSubview(self.tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Binding

    func bind(reactor: UserMoreReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }

}

/**
 * Extensions
 */

private extension UserMoreController {

    // MARK: views (View -> View)

    func bindView(_ reactor: UserMoreReactor) {
        // cancel
        self.barButtonClose.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // informations
        self.buttonChangelog.rx.tap
            .subscribe(onNext: { _ in
                let viewController = HomePageController(reactor: reactor.changelogReactor())
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        self.buttonTermsOfUse.rx.tap
            .subscribe(onNext: { _ in
                if (L10n.linksTerms.prefix(4) == "http") {
                    guard let url = URL(string: L10n.linksTerms) else { return }
                    let svc = SFSafariViewController(url: url)
                    self.present(svc, animated: true, completion: nil)
                } else {
                    let viewController = HomePageController(reactor: reactor.pageReactor(name: L10n.linksTerms))
                    let navigationController = UINavigationController(rootViewController: viewController)
                    self.present(navigationController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        self.buttonPrivacyPolicy.rx.tap
            .subscribe(onNext: { _ in
                if (L10n.linksPrivacy.prefix(4) == "http") {
                    guard let url = URL(string: L10n.linksPrivacy) else { return }
                    let svc = SFSafariViewController(url: url)
                    self.present(svc, animated: true, completion: nil)
                } else {
                    let viewController = HomePageController(reactor: reactor.pageReactor(name: L10n.linksPrivacy))
                    let navigationController = UINavigationController(rootViewController: viewController)
                    self.present(navigationController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        self.buttonLegalNotice.rx.tap
            .subscribe(onNext: { _ in
                if (L10n.linksLegal.prefix(4) == "http") {
                    guard let url = URL(string: L10n.linksLegal) else { return }
                    let svc = SFSafariViewController(url: url)
                    self.present(svc, animated: true, completion: nil)
                } else {
                    let viewController = HomePageController(reactor: reactor.pageReactor(name: L10n.linksLegal))
                    let navigationController = UINavigationController(rootViewController: viewController)
                    self.present(navigationController, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        // error
        self.error.button?.rx.tap
            .subscribe(onNext: { _ in
                if MFMailComposeViewController.canSendMail() {
                    let mvc = MFMailComposeViewController()
                    mvc.mailComposeDelegate = self
                    mvc.setToRecipients([(config["app"]["mails"]["report"].string ?? "")])
                    mvc.setSubject(L10n.userReport)
                    mvc.setMessageBody(setMailError("\(reactor.currentState.error?.title ?? "") \n \(reactor.currentState.error?.description ?? "") \n  \(reactor.currentState.error?.source ?? "")"), isHTML: true)
                    self.present(mvc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: UserMoreReactor) {
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: UserMoreReactor) {
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
        // error
        reactor.state
            .map { $0.error }
            .filterNil()
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { error in
                self.error.configureContent(title: error.title, body: error.description == "" ? error.title : error.description)
                self.error.button?.isHidden = (error.source != nil && error.code != 401) ? false : true
                SwiftMessages.hideAll()
                SwiftMessages.show(config: self.popupConfig, view: self.error)
            })
            .disposed(by: self.disposeBag)
    }
}
