/**
 * Dependencies
 */
import UIKit
import RxCocoa
import RxSwift

/**
 * Dependencies
 */

extension Reactive where Base: UIScrollView {

    var currentPage: Observable<Int> {
        return didEndDecelerating.map({
            let pageWidth = self.base.frame.width
            let pageHorizontal = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            let pageHeight = self.base.frame.height
            let pageVertical = floor((self.base.contentOffset.y - pageHeight / 2) / pageHeight) + 1
            return Int(pageHorizontal != 0 ? pageHorizontal : pageVertical != 0 ? pageVertical : 0 )
        })
    }

    var isReachedBottom: ControlEvent<Void> {
        let source = self.contentOffset
            .filter { [weak base = self.base] _ in
                guard let base = base else { return false }
                return base.isBottom(toleranceHeight: base.frame.height / 2)
            }
            .map { _ in Void() }
        return ControlEvent(events: source)
    }

}
