struct Metric {
    static let primary = UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")
    static let background = UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")
    static let onBackground = UIColor(named: config["theme"]["themes"]["waos"]["onBackground"].string ?? "")
    static let loaderWidth = CGFloat(config["theme"]["loader"]["width"].float ?? 50)
    static let loaderHeight = CGFloat(config["theme"]["loader"]["height"].float ?? 50)
    static let loaderDisplayTimeThreshold = Int(config["theme"]["loader"]["displayTimeThreshold"].int ?? 1000)
    static let loaderMinimumDisplayTime = Int(config["theme"]["loader"]["minimumDisplayTime"].int ?? 2000)
    static let activityType: [NVActivityIndicatorType] = [.ballClipRotate, .ballClipRotateMultiple, .ballClipRotatePulse, .ballDoubleBounce, .ballGridBeat, .ballGridPulse, .ballPulse, .ballPulseRise, .ballPulseSync, .ballRotate, .ballRotateChase, .ballScale, .ballScaleMultiple, .ballScaleRipple, .ballScaleRippleMultiple, .ballSpinFadeLoader, .ballTrianglePath, .circleStrokeSpin, .lineScale, .pacman, .orbit, .lineSpinFadeLoader, .lineScalePulseOut]
}

extension Reactive where Base: NVActivityIndicatorView {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { vc, active in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        }
    }
}

extension Reactive where Base: UIViewController & NVActivityIndicatorViewable {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { vc, active in
            if active {
                vc.startAnimating(CGSize(width: Metric.loaderWidth, height: Metric.loaderHeight),
                message: L10n.loaderMessagee,
                type: Metric.activityType.randomElement()!,
                color: Metric.primary!,
                displayTimeThreshold: Metric.loaderDisplayTimeThreshold,
                minimumDisplayTime: Metric.loaderMinimumDisplayTime,
                backgroundColor: Metric.background!.withAlphaComponent(0.75),
                textColor: Metric.onBackground!)
            } else {
                vc.stopAnimating()
            }
        })
    }

}
