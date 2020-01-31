struct AlertAction {
    var title: String
    var style: UIAlertAction.Style

    static func action(title: String, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIViewController {

    func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction], maxHeight: CGFloat? = 0)
     -> Observable<Int> {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            // heigth
            if(maxHeight != nil && maxHeight ?? 0 > 0) {
                let height: NSLayoutConstraint = NSLayoutConstraint(item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: maxHeight!)
                alertController.view.addConstraint(height)
            }
            // actions
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            // present
            self.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
