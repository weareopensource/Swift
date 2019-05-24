/**
 * protocol
 */

protocol PreferencesServiceType {
    var onBoarded: Bool { get set }
    var isLogged: Bool { get set }
}

/**
 * class
 */

class PreferencesService: PreferencesServiceType {
    var onBoarded: Bool {
        get {
            return UserDefaults.standard[#function] ?? true
        }
        set {
            UserDefaults.standard[#function] = newValue
        }
    }
    var isLogged: Bool {
        get {
            return UserDefaults.standard[#function] ?? true
        }
        set {
            UserDefaults.standard[#function] = newValue
        }
    }
}

/**
 * extension
 */

extension PreferencesService: ReactiveCompatible {}
extension Reactive where Base: PreferencesService {
    var onBoarded: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, #function)
            .map { $0 ?? false }
    }
    var isLogged: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, #function)
            .map { $0 ?? false }
    }
}
