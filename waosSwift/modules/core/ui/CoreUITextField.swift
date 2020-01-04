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

    func setFontAwesomeIcon(_ code: String = "", _ color: UIColor = .gray, padding: Int = 10, size: Int = 22, opacity: CGFloat = 0.5) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding*2, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = UIImage.fontAwesomeIcon(code: code, style: .solid, textColor: color, size: CGSize(width: 22, height: 22))
        iconView.alpha = opacity
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }

    func shared() {
        self.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        self.borderStyle = .none
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        self.leftViewMode = .always
        self.layer.cornerRadius = CGFloat(config["theme"]["global"]["radius"].int ?? 0)
        // prepare for error
        self.layer.borderColor = UIColor(named: config["theme"]["themes"]["waos"]["error"].string ?? "")?.withAlphaComponent(0.75).cgColor
    }

}
