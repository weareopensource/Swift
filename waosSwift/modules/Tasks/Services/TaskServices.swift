/**
 * Dependencies
 */

import RxSwift

/**
 * Service
 */

protocol TaskServiceType {
    func get() -> Observable<[Task]>
}

final class TaskService: TaskServiceType {
    func get() -> Observable<[Task]> {
        let defaultTasks: [Task] = [
            Task(id: "572f16439c0d3ffe0bc084a4", title: "Task one from service"),
            Task(id: "572f16439c0d3ffe0bc084a5", title: "Task two from service"),
            Task(id: "572f16439c0d3ffe0bc084a6", title: "Task three from service")
        ]
        return .just(defaultTasks)
    }
}
