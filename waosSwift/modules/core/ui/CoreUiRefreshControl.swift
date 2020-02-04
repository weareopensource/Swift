@IBDesignable class CoreUIRefreshControl: UIRefreshControl {

    // MARK: Constants

    struct Metric {
        static let primary = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
    }

    // MARK: Initializing

    override init() {
        super.init()
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
        self.tintColor = Metric.primary?.lighter(by: 10)
    }

}
