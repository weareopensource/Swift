import UIKit
import Foundation
import Reusable
import ReactorKit
import RxDataSources

struct MySection {
    var header: String
    var items: [Task]
}

extension MySection: AnimatableSectionModelType {
    typealias Item = Task
    var identity: String {
        return header
    }
    init(original: MySection, items: [Task]) {
        self = original
        self.items = items
    }
}

extension Task: IdentifiableType, Equatable {
    typealias Identity = String
    var identity: Identity { return id }
}

func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id
}

class TasksListController: CoreViewController, StoryboardView, StoryboardBased {

    @IBOutlet var tableView: UITableView!

    let refreshControl = UIRefreshControl()
    let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
        configureCell: { ds, tv, _, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = item.title
            return cell
    }, titleForHeaderInSection: { ds, index in return ds.sectionModels[index].header })
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsSelectionDuringEditing = true
        self.reactor = TasksListReactor() // inject reactor
    }

    func bind(reactor: TasksListReactor) {
        bindAction(reactor)
        bindState(reactor)
        bindView(reactor)
    }
}

private extension TasksListController {
    func bindView(_ reactor: TasksListReactor) {}

    // action (View -> Reactor)
    func bindAction(_ reactor: TasksListReactor) {
        // viewDidLoad
        Observable.just(Void())
            .map { Reactor.Action.get }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        // add
        addButtonItem.rx.tap
            .map { Reactor.Action.create }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    // state (Reactor -> View)
    func bindState(_ reactor: TasksListReactor) {
        // data
        reactor.state.asObservable().map { [MySection(header: "", items: $0.tasks)] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension TasksListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
