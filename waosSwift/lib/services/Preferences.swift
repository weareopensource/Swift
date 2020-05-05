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
    var onBoarded: Bool { get set }
    var isLogged: Bool { get set }
    // global
    var status: Status { get }
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
    // global
    var status: Status {
        get {
            return Status(onBoarded: onBoarded, isLogged: isLogged)
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
    var status: Observable<Status> {
        return  Observable.combineLatest(
            onBoarded, isLogged,
            resultSelector: { onBoarded, isLogged in
                return Status(onBoarded: onBoarded, isLogged: isLogged)
            }
        )
    }
}
