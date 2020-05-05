import Eureka
import RxSwift
import RxCocoa

extension BaseRow: ReactiveCompatible { }

var extensionPropertyStorage: [String: [String: Any]] = [:]

public extension Reactive where Base: BaseRow, Base: RowType {

    var text: ControlProperty<Base.Cell.Value?> {
        let source = Observable<Base.Cell.Value?>.create { [weak base] observer in
            if let strongBase = base {
                observer.onNext(strongBase.value)
                strongBase.onChange { row in
                    observer.onNext(row.value)
                }
            }
            return Disposables.create(with: observer.onCompleted)
        }
        let bindingObserver = Binder(base) { (row, value) in
            row.value = value
        }
        return ControlProperty(values: source, valueSink: bindingObserver)
    }

    var tap: ControlEvent<()> {
        //  let source = methodInvoked(#selector(Base.onCellSelection(_:))).map { _ in }
        let source = Observable<()>.create { [weak base] observer in
            if let _base = base {
                _base.onCellSelection({ (_, _) in
                    observer.onNext(())
                })
            }
            return Disposables.create {
                observer.onCompleted()
            }
        }
        return ControlEvent(events: source)
    }
}
