/**
 * Dependencies
 */

import Eureka

/**
* Extension
*/

extension Form {

    public func mergeErrorToFooter() {
        for section in allSections {
            section.footer?.title = ""
            for row in section {
                if(row.validationErrors.count > 0) {
                    section.footer?.title = "\(section.footer?.title ?? "") \(row.validationErrors.compactMap({ $0.msg }).joined(separator: ". ")). "
                }
            }
            section.reload()
        }
    }

}
