/**
 * Controller
 */

import UIKit

/**
 * IBDesignable
 */

@IBDesignable class CoreUITableView: UITableView {

    // MARK: Constants

    struct Metric {
        static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
        static let surface = UIColor(named: config["theme"]["themes"]["waos"]["surface"].string ?? "")
        static let tableViewRowHeight = CGFloat(config["theme"]["tableView"]["rowHeight"].int ?? 0)
        static let tableViewSectionHeaderHeight = CGFloat(config["theme"]["tableView"]["sectionHeaderHeight"].int ?? 0)
        static let tableViewSectionFooterHeight = CGFloat(config["theme"]["tableView"]["sectionFooterHeight"].int ?? 0)
    }

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
        self.backgroundColor = Metric.background
        self.rowHeight = Metric.tableViewRowHeight
        self.sectionHeaderHeight = Metric.tableViewSectionHeaderHeight
        self.sectionFooterHeight = Metric.tableViewSectionFooterHeight
        // $0.separatorStyle = .none // no border
    }

    func sharedCalc() {
        // tableView
        self.separatorColor = Metric.surface?.darker(by: 8)
    }
}
