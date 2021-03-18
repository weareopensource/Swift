/**
 * Dependencies
 */

import UIKit
import SnapKit

/**
 * extension
 */

extension ConstraintMakerEditable {
    @discardableResult
    func keyboard(_ shown: Bool, in view: UIView) -> ConstraintMakerEditable {
        switch view.traitCollection.verticalSizeClass {
        case .regular:
            if shown { view.shownRegularConstraints.append(constraint) } else { view.hiddenRegularConstraints.append(constraint) }
        case .compact:
            if shown { view.shownCompactConstraints.append(constraint) } else { view.hiddenCompactConstraints.append(constraint) }
        case .unspecified: break
        @unknown default:
            break
        }
        return self
    }
}

private var ckmShownRegular: UInt8 = 0
private var ckmShownCompact: UInt8 = 1
private var ckmHiddenRegular: UInt8 = 2
private var ckmHiddenCompact: UInt8 = 3
extension UIView {

    fileprivate var shownRegularConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmShownRegular) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmShownRegular, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    fileprivate var shownCompactConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmShownCompact) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmShownCompact, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    fileprivate var hiddenRegularConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmHiddenRegular) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmHiddenRegular, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    fileprivate var hiddenCompactConstraints: [Constraint]! {
        get { return objc_getAssociatedObject(self, &ckmHiddenCompact) as? [Constraint] ?? [Constraint]() }
        set(newValue) { objc_setAssociatedObject(self, &ckmHiddenCompact, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    @objc private dynamic func keyboardWillShow(notification: Notification) {
        let duration = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let option = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber

        switch traitCollection.verticalSizeClass {
        case .regular:
            hiddenRegularConstraints.forEach { $0.deactivate() }
            shownRegularConstraints.forEach { $0.activate() }
        case .compact:
            hiddenCompactConstraints.forEach { $0.deactivate() }
            shownCompactConstraints.forEach { $0.activate() }
        case .unspecified: break
        @unknown default:
            break
        }

        UIView.animate(withDuration: duration, delay: 0,
                       options: UIView.AnimationOptions(rawValue: option.uintValue), animations: {
                        self.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private dynamic func keyboardWillHide(notification: Notification) {
        let duration = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let option = (notification as NSNotification).userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber

        switch traitCollection.verticalSizeClass {
        case .regular:
            shownRegularConstraints.forEach { $0.deactivate() }
            hiddenRegularConstraints.forEach { $0.activate() }
        case .compact:
            shownCompactConstraints.forEach { $0.deactivate() }
            hiddenCompactConstraints.forEach { $0.activate() }
        case .unspecified: break
        @unknown default:
            break
        }

        UIView.animate(withDuration: duration, delay: 0,
                       options: UIView.AnimationOptions(rawValue: option.uintValue), animations: {
                        self.layoutIfNeeded()
        }, completion: nil)
    }

    func registerAutomaticKeyboardConstraints() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
