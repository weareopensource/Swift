@IBDesignable class CorUITableView: UITableView {

    // MARK: Initializing

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        sharedCalc()
    }

    func shared() {
        // tableView
        self.backgroundColor = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
        self.rowHeight = CGFloat(config["theme"]["tableView"]["rowHeight"].int ?? 0)
        self.sectionHeaderHeight = CGFloat(config["theme"]["tableView"]["sectionHeaderHeight"].int ?? 0)
        self.sectionFooterHeight = CGFloat(config["theme"]["tableView"]["sectionFooterHeight"].int ?? 0)
        // $0.separatorStyle = .none // no border
    }

    func sharedCalc() {
        // tableView
        self.separatorColor = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")?.darker(by: 8)
    }
}
