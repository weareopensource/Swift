/**
 * Dependencies
 */

import UIKit

/**
 * extension
 */

extension UINavigationController {
    /**
     * @desc clear navigation controller background
     */
    func clear() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.navigationBar.backgroundColor = .clear
    }
}
