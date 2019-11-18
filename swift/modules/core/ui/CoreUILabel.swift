@IBDesignable class CoreUILabel: UILabel {

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
        self.textColor = UIColor(named: config["theme"]["themes"]["waos"]["onSurface"].string ?? "")
    }

}
