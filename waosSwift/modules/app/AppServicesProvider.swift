protocol AppServicesProviderType: class {
    var taskService: TasksServiceType { get }
    var authService: AuthServiceType { get }
    var userService: UserServiceType { get }
    var preferencesService: PreferencesService { get }
}

final class AppServicesProvider: AppServicesProviderType {
    lazy var taskService: TasksServiceType = TasksService(provider: self)
    lazy var authService: AuthServiceType = AuthService(provider: self)
    lazy var userService: UserServiceType = UserService(provider: self)
    lazy var preferencesService: PreferencesService = PreferencesService()
}
