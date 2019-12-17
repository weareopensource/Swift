@IBDesignable class CoreUIRefreshControl: UIRefreshControl {

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
        self.tintColor = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
    }

}
