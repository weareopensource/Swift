@IBDesignable class CoreUIRefreshControl: UIRefreshControl {

    // MARK: Constants

    struct Metric {
        static let onBackground = UIColor(named: config["theme"]["themes"]["waos"]["onBackground"].string ?? "")
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
        self.tintColor = Metric.onBackground
    }

}
