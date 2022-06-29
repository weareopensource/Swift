/**
 * Controller
 */

import UIKit

/**
 * IBDesignable
 */

@IBDesignable class CoreUITextField: UITextField {

    // MARK: Constants

    var icon: String = ""
    struct Metric {
        static let surface = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        static let error = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")
        static let radius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
    }

    // MARK: Initializing

    override init(frame: CGRect) {
        super.init(frame: frame)
        shared()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        shared()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        shared()
    }
    
    override func didMoveToSuperview() {
        if(self.icon != "") {
            self.setFontAwesomeIcon(self.icon)
        }
    }
    
    func shared() {
        self.backgroundColor = Metric.surface
        self.borderStyle = .none
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftViewMode = .always
        self.layer.cornerRadius = Metric.radius
        // prepare for error
        self.layer.borderColor = Metric.error?.withAlphaComponent(0.75).cgColor
    }
    
    public func error() {
        self.layer.borderWidth = 1.0
        self.setFontAwesomeIcon(icon, Metric.error?.lighter() ?? .red)
    }
    
    public func valid() {
        self.layer.borderWidth = 0
        self.setFontAwesomeIcon(icon, .gray)
    }

}
