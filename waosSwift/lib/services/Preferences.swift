import Foundation

protocol PreferencesServiceType {
    var onBoarded: Bool { get set }
}

class PreferencesService: PreferencesServiceType {
    var onBoarded: Bool {
        get {
            return UserDefaults.standard[#function] ?? true
        }
        set {
            UserDefaults.standard[#function] = newValue
        }
    }
}

extension PreferencesService: ReactiveCompatible {}
extension Reactive where Base: PreferencesService {
    var onBoarded: Observable<Bool> {
        return UserDefaults.standard
            .rx
            .observe(Bool.self, #function)
            .map { $0 ?? false }
    }
}
