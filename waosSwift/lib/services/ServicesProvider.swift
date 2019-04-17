protocol ServicesProviderType {
    var preferencesService: PreferencesService { get }
}

struct ServicesProvider: ServicesProviderType {
    let preferencesService: PreferencesService
}
