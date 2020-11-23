/**
 * Dependencies
 */

import UIKit
import ReactorKit
import WebKit

/**
 * Controller
 */

class HomeTermsController: CoreController, View, NVActivityIndicatorViewable {

    // MARK: UI

    let webView = WKWebView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    let buttonAccept = CoreUIButton().then {
        $0.setTitle(L10n.modalRequirementAccept, for: .normal)
        $0.setTitleColor(Metric.onPrimary, for: .normal)
        $0.backgroundColor = Metric.primary
        $0.setBackgroundColor(color: Metric.primary?.lighter(by: 14) ?? .white, forState: .highlighted)
    }

    // MARK: Initializing

    init(reactor: HomeTermsReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.webView)
        self.view.addSubview(self.buttonAccept)
    }

    override func setupConstraints() {
        self.webView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self.view)
        }
        self.buttonAccept.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-Metric.margin*2)
        }
    }

    // MARK: Binding

    func bind(reactor: HomeTermsReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension HomeTermsController {

    // MARK: views (View -> View)

    func bindView(_ reactor: HomeTermsReactor) {
        // cancel
        self.buttonAccept.rx.tap
            .throttle(.milliseconds(Metric.timesButtonsThrottle), latest: false, scheduler: MainScheduler.instance)
            .map { Reactor.Action.done }
            .bind(to: reactor.action)
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

    func bindAction(_ reactor: HomeTermsReactor) {
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: HomeTermsReactor) {
        // pages
        reactor.state
            .map { $0.pages }
            .distinctUntilChanged()
            .filterEmpty()
            .subscribe(onNext: { pages in
                self.webView.loadHTMLString(generateWebPage(pages[0].markdown, style: reactor.currentState.style, links: reactor.currentState.displayLinks, head: false), baseURL: nil)
            })
            .disposed(by: self.disposeBag)
        // dissmiss
        reactor.state
            .map { $0.isDismissed }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
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
