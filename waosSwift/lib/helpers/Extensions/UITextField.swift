extension UITextField {
    /**
    * @desc set left font awesome icon on
    * @param {String} icon code,
    * @param {FontAwesomeStyle} icon style,
    * @param {UIColor} icon color,
    * @param {Int} icon padding,
    * @param {Int} icon size,
    * @param {CGFloat} icon opacity,
    */
    public func setFontAwesomeIcon(_ code: String = "", style: FontAwesomeStyle = .solid, _ color: UIColor = .gray, padding: Int = 10, size: Int = 22, opacity: CGFloat = 0.5) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding*2, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = UIImage.fontAwesomeIcon(code: code, style: style, textColor: color, size: CGSize(width: 22, height: 22))
        iconView.alpha = opacity
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }

}
