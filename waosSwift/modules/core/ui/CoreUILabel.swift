@IBDesignable class CoreUILabel: UILabel {

    // MARK: Constants

    struct Metric {
        static let onSurface = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
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

    func shared() {
        self.textColor = Metric.onSurface
    }

}
