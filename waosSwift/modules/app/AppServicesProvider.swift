protocol AppServicesProviderType: class {
    var taskService: TaskServiceType { get }
}

final class AppServicesProvider: AppServicesProviderType {
    lazy var taskService: TaskServiceType = TaskService(provider: self)
}
