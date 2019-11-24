/**
 * Service
 */

protocol TasksServiceType {
    var tasks: Observable<[Tasks]?> { get }

    func list() -> Observable<MyResult<TasksResponse, CustomError>>
    func create(_ task: Tasks) -> Observable<MyResult<TaskResponse, CustomError>>
    func update(_ task: Tasks) -> Observable<MyResult<TaskResponse, CustomError>>
    func delete(_ task: Tasks) -> Observable<MyResult<DeleteResponse, CustomError>>
}

final class TasksService: CoreService, TasksServiceType {
    fileprivate let networking = Networking<TasksApi>(plugins: [CookiePlugin()])

    // temporary array
    var defaultTasks: [Tasks] = [Tasks()]

    fileprivate let tasksSubject = ReplaySubject<[Tasks]?>.create(bufferSize: 1)
    lazy var tasks: Observable<[Tasks]?> = self.tasksSubject.asObservable()
        .startWith(nil)
        .share(replay: 1)

    func list() -> Observable<MyResult<TasksResponse, CustomError>> {
        log.verbose("🔌 service : get")
        return self.networking
            .request(.list)
            .map(TasksResponse.self)
            .map { response in
                self.defaultTasks = response.data
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func create(_ task: Tasks) -> Observable<MyResult<TaskResponse, CustomError>> {
        log.verbose("🔌 service : create")
        return self.networking
            .request(.create(task))
            .map(TaskResponse.self)
            .map { response in
                self.defaultTasks.insert(response.data, at: 0)
                self.tasksSubject.onNext(self.defaultTasks)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func update(_ task: Tasks) -> Observable<MyResult<TaskResponse, CustomError>> {
        log.verbose("🔌 service : update")
        return self.networking
            .request(.update(task))
            .map(TaskResponse.self)
            .map { response in
                if let index = self.defaultTasks.firstIndex(where: { $0.id == response.data.id }) {
                    self.defaultTasks[index] = response.data
                }
                self.tasksSubject.onNext(self.defaultTasks)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }

    func delete(_ task: Tasks) -> Observable<MyResult<DeleteResponse, CustomError>> {
        log.verbose("🔌 service : delete")
        return self.networking
            .request(.delete(task))
            .map(DeleteResponse.self)
            .map { response in
                if let index = self.defaultTasks.firstIndex(where: { $0.id == response.data.id }) {
                    self.defaultTasks.remove(at: index)
                }
                self.tasksSubject.onNext(self.defaultTasks)
                return response
            }
            .asObservable()
            .map(MyResult.success)
            .catchError { err in .just(.error(getError(err)))}
    }
}
