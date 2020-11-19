extension UISegmentedControl {

    func updateTitle(_ titles: [String?]) {
     removeAllSegments()
        for t in titles {
            insertSegment(withTitle: t, at: numberOfSegments, animated: true)
        }

     }

}

func fixBackgroundSegmentControl( _ segmentControl: UISegmentedControl) {
    if #available(iOS 13.0, *) {
        //just to be sure it is full loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in 0...(segmentControl.numberOfSegments-1) {
                let backgroundSegmentView = segmentControl.subviews[i]
                //it is not enogh changing the background color. It has some kind of shadow layer
                backgroundSegmentView.isHidden = true
            }
        }
    }
}
