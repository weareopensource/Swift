/**
 * Controller
 */

import UIKit

/**
 * IBDesignable
 */

@IBDesignable class CoreUIButton: UIButton {

    // MARK: Constants

    struct Metric {
        static let surface = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        static let onSurface = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
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

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.highlightBtn()
            } else {
                self.clearHighlighted()
            }
        }
    }

    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.4
        }
    }

    func highlightBtn() {
        if traitCollection.userInterfaceStyle == .light {
            self.backgroundColor = Metric.surface!.darker(by: 5)
        } else {
            self.backgroundColor = Metric.surface!.lighter(by: 5)
        }

    }

    func clearHighlighted() {
        self.backgroundColor = Metric.surface
    }

    func shared() {
        self.layer.cornerRadius = Metric.radius
        self.backgroundColor = Metric.surface
        self.setTitleColor(Metric.onSurface, for: .normal)

        // animation at first launch
        self.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        })
    }
}
