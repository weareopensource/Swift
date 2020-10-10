/**
 * Dependencies
 */

import Eureka

/**
* Extension
*/

extension Form {
    /**
    * @desc merge error of sections to footer of it
    */
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

extension TextRow {
    /**
    * @desc set left font awesome icon on
    * @param {String} icon code,
    * @param {FontAwesomeStyle} icon style,
    * @param {UIColor} icon color,
    * @param {Int} icon padding,
    * @param {Int} icon size,
    * @param {CGFloat} icon opacity,
    */
    public func setFontAwesomeIcon(_ code: String = "", style: FontAwesomeStyle = .solid, color: UIColor = .gray, padding: Int = 5, size: Int = 22, opacity: CGFloat = 0.5) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding*2, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.image = UIImage.fontAwesomeIcon(code: code, style: style, textColor: color, size: CGSize(width: 22, height: 22))
        iconView.alpha = opacity
        outerView.addSubview(iconView)
        cell.textField.leftView = outerView
        cell.textField.leftViewMode = .always
    }

}

extension EmailRow {
    /**
    * @desc set left font awesome icon on
    * @param {String} icon code,
    * @param {FontAwesomeStyle} icon style,
    * @param {UIColor} icon color,
    * @param {Int} icon padding,
    * @param {Int} icon size,
    * @param {CGFloat} icon opacity,
    */
    public func setFontAwesomeIcon(_ code: String = "", style: FontAwesomeStyle = .solid, color: UIColor = .gray, padding: Int = 5, size: Int = 22, opacity: CGFloat = 0.5) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding*2, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        iconView.image = UIImage.fontAwesomeIcon(code: code, style: style, textColor: color, size: CGSize(width: 22, height: 22))
        iconView.alpha = opacity
        outerView.addSubview(iconView)
        cell.textField.leftView = outerView
        cell.textField.leftViewMode = .always
    }

}
