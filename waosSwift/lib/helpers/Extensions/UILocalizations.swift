/**
 * Dependencies
 */

import UIKit

/**
 * @desc Extension of UILabel which allows to select a localization string "localizableText" from the storyboard
 */
extension UILabel {
    @IBInspectable var localizableText: String? {
        get { return "" }
        set(value) { text = NSLocalizedString(value!, comment: "") }
    }
}

/**
 * @desc Extension of String which allows to select a localization string "localizableText" from the storyboard
 */
extension String {
    var localized: String {
        get { return NSLocalizedString(self, comment: "") }
    }
}

/**
 * @desc Extension of UIButton which allows to select a localization string "localizableText" from the storyboard
 */
extension UIButton {
    @IBInspectable var localizedTitle: String {
        get { return "" }
        set { self.setTitle(newValue.localized, for: .normal) }
    }
}
