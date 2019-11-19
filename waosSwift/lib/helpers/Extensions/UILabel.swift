extension UILabel {
    /**
    * @desc set new spacing for uilabel, line and letters
    * @param {CGFloat} lineSpacing,
    * @param {CGFloat} letterSpacing,
    */
    func setSpacing(lineSpacing: CGFloat = 0.0, letterSpacing: CGFloat = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.lineHeightMultiple = lineSpacing
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
            self.attributedText = attributedString
        }
    }
}
