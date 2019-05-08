/**
 * Dependencies
 */

import UIKit
import Foundation
import Reusable
import ReactorKit
import RxDataSources

/**
 * Controller
 */

final class TasksListController: CoreController, View {

    // MARK: Constants

    struct Reusable {
        static let taskCell = ReusableCell<TaskCellController>()
    }

    // MARK: UI

    let tableView = UITableView().then {
        $0.register(Reusable.taskCell)
        $0.allowsSelectionDuringEditing = true
        $0.rowHeight = 75
    }
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    // MARK: Properties

    let dataSource = RxTableViewSectionedReloadDataSource<Sections>(
        configureCell: { _, tableView, indexPath, reactor in
            let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
            cell.reactor = reactor
            return cell
    })

    // MARK: Initializing

    init(reactor: TasksListReactor) {
        super.init()
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        self.reactor = reactor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }

    override func setupConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
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
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.dataSource.canEditRowAtIndexPath = { _, _  in true }

        // add
        self.tableView.rx.modelSelected(type(of: self.dataSource).Section.Item.self)
            .map(reactor.editReactor)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = TaskController(reactor: reactor)
                viewController.titleInput.text = reactor.initialState.task.title
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        // add
        self.addButtonItem.rx.tap
            .map(reactor.addReactor)
            .subscribe(onNext: { [weak self] reactor in
                guard let `self` = self else { return }
                let viewController = TaskController(reactor: reactor)
                let navigationController = UINavigationController(rootViewController: viewController)
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }

    // MARK: actions (View -> Reactor)

    func bindAction(_ reactor: TasksListReactor) {
        // viewDidLoad
        self.rx.viewDidLoad
            .map { Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // delete
        self.tableView.rx.itemDeleted
            .map(Reactor.Action.delete)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }

    // MARK: states (Reactor -> View)

    func bindState(_ reactor: TasksListReactor) {
        // data
        reactor.state.asObservable().map { $0.tasks }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
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
