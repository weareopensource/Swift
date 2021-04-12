/**
 * Dependencies
 */

import UIKit
import Reusable
import ReactorKit
import RxDataSources
import RxRelay
import SwiftMessages
import MessageUI

/**
 * Controller
 */

final class TasksListController: CoreController, View {

    // MARK: Constants

    fileprivate var notification = BehaviorRelay<String?>(value: nil)
    struct Reusable {
        static let taskCell = ReusableCell<TasksCellController>()
    }

    // MARK: UI

    let tableView = CoreUITableView().then {
        $0.register(Reusable.taskCell)
        $0.allowsSelectionDuringEditing = true
    }
    let barButtonAdd = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    let refreshControl = CoreUIRefreshControl()

    // MARK: Properties

    let dataSource = RxTableViewSectionedReloadDataSource<TasksSections>(
        configureCell: { _, tableView, indexPath, reactor in
            let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
            cell.reactor = reactor
            return cell
        })
    //let steps = PublishRelay<Step>()
    let application = UIApplication.shared

    // MARK: Initializing

    init(reactor: TasksListReactor) {
        super.init()
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.barButtonAdd
        self.tableView.refreshControl = refreshControl
        self.view.addSubview(self.tableView)
        // notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.ReceivedNotification(notification:)), name: Notification.Name("openTask"), object: nil)
    }

    override func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }

    // MARK: Notification

    @objc func ReceivedNotification(notification: Notification) {
        if let id = notification.userInfo?["id"] as? String {
            self.notification.accept(id)
        } else {
            self.notification.accept(nil)
        }
    }

    // MARK: Binding

    func bind(reactor: TasksListReactor) {
        bindView(reactor)
        bindAction(reactor)
        bindState(reactor)
    }
}

private extension TasksListController {

    // MARK: views (View -> View)

    func bindView(_ reactor: TasksListReactor) {
        // tableview
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.dataSource.canEditRowAtIndexPath = { _, _  in true }
        // item selected
        self.tableView.rx.modelSelected(TasksSections.Item.self)
            .subscribe(onNext: { result in
                let viewController = TasksViewController(reactor: reactor.editReactor(result))
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // add button
        self.barButtonAdd.rx.tap
            .subscribe(onNext: { _ in
                let viewController = TasksViewController(reactor: reactor.addReactor())
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
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

    func bindAction(_ reactor: TasksListReactor) {
        // checks
        self.application.rx.didOpenApp
            .map { Reactor.Action.checkUserToken }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        self.application.rx.didOpenApp
            .map { Reactor.Action.checkUserTerms }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // init
        self.rx.viewWillAppear
            .throttle(.milliseconds(Metric.timesRefreshData), latest: false, scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // refresh
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // delete
        self.tableView.rx.itemDeleted
            .map(Reactor.Action.delete)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // notification
        self.notification
            .map {Reactor.Action.getIndexPath($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: TasksListReactor) {
        // tasks
        reactor.state
            .map { $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        // refreshing
        reactor.state
            .map { $0.isRefreshing }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        // notification
        reactor.state
            .map { $0.indexPath }
            .filterNil()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                self.tableView.delegate?.tableView!(self.tableView, didSelectRowAt: indexPath)
            })
            .disposed(by: self.disposeBag)
        // user
        reactor.state
            .map { $0.terms }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { terms in
                let viewController = HomeTermsController(reactor: reactor.termsReactor(terms: terms))
                viewController.title = L10n.modalRequirementTitle
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
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

/**
 * Extensions
 */

extension TasksListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
