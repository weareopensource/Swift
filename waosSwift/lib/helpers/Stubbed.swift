/**
 * Dependencies
 */

import UIKit

/**
 * functions
 */

/**
 * @desc return stubbed json response mock
 * @param {String} filename
 * @return {Data} file
 */
func stubbed(_ filename: String) -> Data! {
    @objc class TestClass: NSObject {}

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}
