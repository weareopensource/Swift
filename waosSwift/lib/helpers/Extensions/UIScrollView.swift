/**
 * Dependencies
 */

import UIKit

/**
 * Dependencies
 */

extension UIScrollView {

    func isBottom(toleranceHeight: CGFloat) -> Bool {
        return contentOffset.y > contentSize.height - frame.height + contentInset.bottom - toleranceHeight
    }

    func isNeedScroll() -> Bool {
        return (contentSize.width > self.frame.width) ||
               (contentSize.height > self.frame.height)
    }

    func scrollToBottom(animation: Bool) {
        scrollToBottom(offset: 0, animation: animation)
    }

    func scrollToBottom(offset: CGFloat, animation: Bool) {
        UIView.animate(withDuration: animation ? 0.25 : 0) {
            self.contentOffset = CGPoint(x: self.contentOffset.x,
                                         y: self.contentSize.height - self.frame.size.height + self.contentInset.bottom + offset)
        }
    }

    var remaining: CGPoint {
        let horizontal = self.contentSize.width - self.frame.width - self.contentOffset.x
        let vertical = self.contentSize.height - self.frame.height - self.contentOffset.y
        return CGPoint(x: horizontal, y: vertical)
    }

    func setCurrentPage(_ page: Int, animated: Bool) {
        var rect = bounds
        rect.origin.x = rect.width * CGFloat(page)
        rect.origin.y = 0
        scrollRectToVisible(rect, animated: animated)
    }
}
