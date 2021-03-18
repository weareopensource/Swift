/**
 * Dependencies
 */

import UIKit

/**
 * Functions
 */

/**
* @desc make circular view, must be called in override func layoutSubviews
* @param {UIView} _view,
*/
func makeCircular(_ view: UIView) {
    view.layer.cornerRadius = view.bounds.size.width / 2.0
    view.clipsToBounds = true
}
