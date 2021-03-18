/**
 * Dependencies
 */

import UIKit
import RxSwift
import ReactorKit
import SwiftSpinner

/**
 * Extension
 */

extension Reactive where Base: UIViewController {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { _, active in
            if active {
                SwiftSpinner.show(delay: Double(config["theme"]["loader"]["minimumDisplayTime"].int ?? 2000)/1000, title: [
                    "Swapping time and space...",
                    "Loading the Loading message...",
                    "E.T phone loading...",
                    "Swapping time and space...",
                    "Have a good day.",
                    "May the force be with you!",
                    "Don't panic...",
                    "We're making you a cookie.",
                    "Is this Windows?",
                    "Spinning the hamster...",
                    "Dividing by zero...",
                    "Winter is coming...",
                    "Pushing pixels...",
                    "Change the world by being yourself."
                ].randomElement()!)
            } else {
                SwiftSpinner.hide()
            }
        }
    }
}
