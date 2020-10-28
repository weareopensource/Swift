/**
 * Dependencies
 */

import KeychainAccess

/**
 * Struct
 */

struct Status {
    var onBoarded: Bool
    var isLogged: Bool

    init(onBoarded: Bool, isLogged: Bool) {
        self.onBoarded = onBoarded
        self.isLogged = isLogged
    }
}

/**
 * protocol
 */

protocol PreferencesServiceType {
    // global
    var onBoarded: Bool { get set }
    var isLogged: Bool { get set }
    // status
    var status: Status { get }
    // options
    var isBackground: Bool { get set }
}

/**
 * class
 */

class PreferencesService: PreferencesServiceType {
    // global
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
            if(!newValue) {
                do {
                    try keychain.remove("Cookie")
                } catch let error {
                    log.error(error)
                }
            }
            UserDefaults.standard[#function] = newValue
        }
    }
    // status
    var status: Status {
        get {
            return Status(onBoarded: onBoarded, isLogged: isLogged)
        }
    }
    // options
    var isBackground: Bool {
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
    // global
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
    // status
    var status: Observable<Status> {
        return  Observable.combineLatest(
            onBoarded, isLogged,
            resultSelector: { onBoarded, isLogged in
                return Status(onBoarded: onBoarded, isLogged: isLogged)
            }
        )
    }
    // options
    var isBackground: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, #function)
            .map { $0 ?? true }
    }
}
