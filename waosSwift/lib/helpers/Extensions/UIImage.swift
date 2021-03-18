/**
 * Dependencies
 */

import UIKit

/**
 * extension
 */

extension UIImage {
    /**
     * @desc set blur effect on UIImageView with a radius coefficient
     * @param {CGFloat} radius,
     */
    func blurred(radius: CGFloat) -> UIImage {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let clampFilter = CIFilter(name: "CIAffineClamp") else { return self }
        clampFilter.setDefaults()
        clampFilter.setValue(inputImage, forKey: kCIInputImageKey)
        guard let ciFilter = CIFilter(name: "CIGaussianBlur") else { return self }
        ciFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        ciFilter.setValue(radius, forKey: "inputRadius")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }

    /**
     * @desc lighter image
     * @param {CGFloat} percentage,
     */
    func lighter(by percentage: CGFloat = 30) -> UIImage? {
        return self.adjust(by: abs(percentage) )
    }

    /**
     * @desc darker image
     * @param {CGFloat} percentage,
     */
    func darker(by percentage: CGFloat = 30) -> UIImage? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    /**
     * @desc adjust image darkness / lightness from coefficient
     * @param {CGFloat} percentage,
     */
    func adjust(by percentage: CGFloat = 30) -> UIImage? {
        let ciContext = CIContext(options: nil)
        guard let cgImage = cgImage else { return self }
        let inputImage = CIImage(cgImage: cgImage)
        guard let ciFilter = CIFilter(name: "CIExposureAdjust") else { return self }
        ciFilter.setValue(inputImage, forKey: "inputImage")
        ciFilter.setValue(percentage/100, forKey: "inputEV")
        guard let resultImage = ciFilter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
        guard let cgImage2 = ciContext.createCGImage(resultImage, from: inputImage.extent) else { return self }
        return UIImage(cgImage: cgImage2)
    }

    /**
     * @desc adjust image orientation if needed in exif
     */
    func adjustOrientation() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
}
