/**
 * Dependencies
 */

import ReactorKit

//enum TaskEvent {
//    case refresh([Task])
//}

/**
 * Service
 */

protocol TaskServiceType {
    var tasks: Observable<[Task]?> { get }

    func get() -> Observable<[Task]>
    func create(title: String) -> Observable<Task>
    func save(task: Task) -> Observable<Task>
    func delete(task: Task) -> Observable<Void>
}

final class TaskService: CoreService, TaskServiceType {
    // temporary array
    var defaultTasks: [Task] = [
        Task(id: "572f16439c0d3ffe0bc084a4", title: "Task one from service"),
        Task(id: "572f16439c0d3ffe0bc084a5", title: "Task two from service"),
        Task(id: "572f16439c0d3ffe0bc084a6", title: "Task three from service")
    ]

    fileprivate let tasksSubject = ReplaySubject<[Task]?>.create(bufferSize: 1)
    lazy var tasks: Observable<[Task]?> = self.tasksSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)

    func get() -> Observable<[Task]> {
        print("service get")
        return .just(self.defaultTasks)
    }

    func create(title: String) -> Observable<Task> {
        print("service create")
        let newTask = Task(id: "572f16439c0d3ffe0bc084a7", title: title)
        self.defaultTasks.append(newTask)
        self.tasksSubject.onNext(self.defaultTasks)
        return .just(newTask)
    }

    func save(task: Task) -> Observable<Task> {
        print("service save")
        let newTask = Task(id: task.id, title: task.title)
        if let index = self.defaultTasks.firstIndex(where: { $0.id == task.id }) {
            self.defaultTasks[index] = newTask
        }
        self.tasksSubject.onNext(self.defaultTasks)
        return .just(newTask)
    }

    func delete(task: Task) -> Observable<Void> {
        print("service delete")
        if let index = self.defaultTasks.firstIndex(where: { $0.id == task.id }) {
             self.defaultTasks.remove(at: index)
        }
        self.tasksSubject.onNext(self.defaultTasks)
        return .just(Void())
    }
}
