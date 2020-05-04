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
                vc.startAnimating(CGSize(width: CGFloat(config["theme"]["loader"]["width"].float ?? 50), height: CGFloat(config["theme"]["loader"]["height"].float ?? 50)),
                message: L10n.loaderMessagee,
                type: [.ballClipRotate, .ballClipRotateMultiple, .ballClipRotatePulse, .ballDoubleBounce, .ballGridBeat, .ballGridPulse, .ballPulse, .ballPulseRise, .ballPulseSync, .ballRotate, .ballRotateChase, .ballScale, .ballScaleMultiple, .ballScaleRipple, .ballScaleRippleMultiple, .ballSpinFadeLoader, .ballTrianglePath, .circleStrokeSpin, .lineScale, .pacman, .orbit, .lineSpinFadeLoader, .lineScalePulseOut].randomElement()!,
                color: UIColor(named: config["theme"]["themes"]["waos"]["primary"].string ?? "")!,
                displayTimeThreshold: Int(config["theme"]["loader"]["displayTimeThreshold"].int ?? 1000),
                minimumDisplayTime: Int(config["theme"]["loader"]["minimumDisplayTime"].int ?? 2000),
                backgroundColor: UIColor(named: config["theme"]["themes"]["waos"]["background"].string ?? "")!.withAlphaComponent(0.75),
                textColor: UIColor(named: config["theme"]["themes"]["waos"]["onBackground"].string ?? "")!)
            } else {
                vc.stopAnimating()
            }
        })
    }

}
