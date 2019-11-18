@IBDesignable class CoreUITextField: UITextField {

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
        self.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        self.borderStyle = .none
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.layer.cornerRadius = 5.0
    }

}
