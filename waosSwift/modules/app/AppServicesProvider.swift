protocol AppServicesProviderType: class {
    var taskService: TaskServiceType { get }
    var preferencesService: PreferencesService { get }
}

final class AppServicesProvider: AppServicesProviderType {
    lazy var taskService: TaskServiceType = TaskService(provider: self)
    lazy var preferencesService: PreferencesService = PreferencesService()
}
