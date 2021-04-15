/**
 * Dependencies
 */

import UIKit
import RxSwift
import ReactorKit
import WebKit
import MessageUI
import SwiftMessages

/**
 * Controller
 */

class HomePageController: CoreController, View {

    // MARK: UI

    let barButtonClose = UIBarButtonItem(barButtonSystemItem: .close, target: nil, action: nil)

    let segmentedControlTitles = UISegmentedControl().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Metric.background
    }
    let webView = WKWebView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }

    // MARK: Properties

    let application = UIApplication.shared

    // MARK: Initializing

    init(reactor: HomePageReactor) {
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
        self.view.addSubview(self.segmentedControlTitles)

        self.navigationController?.clear()
        self.navigationItem.leftBarButtonItem = self.barButtonClose
    }

    override func setupConstraints() {
        self.segmentedControlTitles.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(Metric.margin)
            make.right.equalTo(self.view).inset(Metric.margin)
            make.top.equalTo(self.view).offset(55 + Metric.margin)
            make.height.equalTo(50)
        }
        self.webView.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self.view)
        }
    }

    // MARK: Binding

    func bind(reactor: HomePageReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

/**
 * Extensions
 */

private extension HomePageController {

    // MARK: views (View -> View)

    func bindView(_ reactor: HomePageReactor) {
        // cancel
        self.barButtonClose.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // segmented
        self.segmentedControlTitles.rx.value
            .skip(1)
            .subscribe(onNext: { index in
                self.webView.loadHTMLString(generateWebPage(reactor.currentState.pages[index].markdown, style: reactor.currentState.style, links: reactor.currentState.displayLinks, head: reactor.currentState.pages.count > 1 ? true : false), baseURL: nil)
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
                    mvc.setMessageBody(setMailError("\(reactor.currentState.error?.title ?? "") \n \(reactor.currentState.error?.description ?? "") \n  \(reactor.currentState.error?.source ?? "")"), isHTML: true)
                    self.present(mvc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: HomePageReactor) {
        // init
        self.rx.viewWillAppear
            .throttle(.milliseconds(Metric.timesRefreshData), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: HomePageReactor) {
        // refreshing
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        //pages
        reactor.state
            .map { $0.pages }
            .distinctUntilChanged()
            .filterEmpty()
            .subscribe(onNext: { pages in
                let titles =  pages.map { $0.title }
                self.segmentedControlTitles.isHidden = pages.count > 1 ? false : true
                self.segmentedControlTitles.updateTitle(titles)
                self.segmentedControlTitles.selectedSegmentIndex = 0
                self.webView.loadHTMLString(generateWebPage(pages[0].markdown, style: reactor.currentState.style, links: reactor.currentState.displayLinks, head: pages.count > 1 ? true : false), baseURL: nil)
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
