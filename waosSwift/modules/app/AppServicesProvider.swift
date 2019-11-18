protocol AppServicesProviderType: class {
    var tasksService: TasksServiceType { get }
    var authService: AuthServiceType { get }
    var userService: UserServiceType { get }
    var preferencesService: PreferencesService { get }
}

final class AppServicesProvider: AppServicesProviderType {
    lazy var tasksService: TasksServiceType = TasksService(provider: self)
    lazy var authService: AuthServiceType = AuthService(provider: self)
    lazy var userService: UserServiceType = UserService(provider: self)
    lazy var preferencesService: PreferencesService = PreferencesService()
}
