/**
 * Dependencies
 */

import UIKit

/**
 * Functions
 */

/**
* @desc make CircleUIButton
*/
class CircleUIButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
