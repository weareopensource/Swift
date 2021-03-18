/**
 * Dependencies
 */

import UIKit
import Kingfisher

/**
 * Extension
 */

typealias ImageOptions = KingfisherOptionsInfo

enum imageStyle {
    case blured
    case bw
    case bwBlured
    case animated
}

extension UIImageView {

    struct Metric {
        static let imgStylesBlured = CGFloat(config["img"]["styles"]["blured"].float ?? 10)
        static let imgStylesOverlayFraction = CGFloat(config["img"]["styles"]["overlayFraction"].float ?? 0.9)
    }

    @discardableResult
    func setImage(
        url: String?,
        placeholder: UIImage? = nil,
        options: ImageOptions? = nil,
        style: imageStyle? = nil,
        defaultImage: String? = nil, // should be a Bundle.main.path image png
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {

        // Custome Filters add
        var options = options ?? []
        switch style {
        case .animated:
            options.append(.cacheSerializer(FormatIndicatedCacheSerializer.gif))
            options.append(.forceRefresh)
        case .blured:
            options.append(.processor(
                OverlayImageProcessor(overlay: .black, fraction: Metric.imgStylesOverlayFraction)
                    |> BlurImageProcessor(blurRadius: Metric.imgStylesBlured)
            ))
        case .bw:
            options.append(.processor(
                OverlayImageProcessor(overlay: .black, fraction: Metric.imgStylesOverlayFraction)
                |> BlackWhiteProcessor()
            ))
        case .bwBlured:
            options.append(.processor(
                OverlayImageProcessor(overlay: .black, fraction: Metric.imgStylesOverlayFraction)
                |> BlurImageProcessor(blurRadius: Metric.imgStylesBlured)
                |> BlackWhiteProcessor()
            ))
        default:
            break
        }

        // GIF will only animates in the AnimatedImageView
        if self is AnimatedImageView == false {
            options.append(.onlyLoadFirstFrame)
        }

        if(defaultImage != nil && (url == "default" || url == "default.png" || url == "default.jpg" || url == "")) {
            let provider = LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: defaultImage, ofType: "png") ?? ""))
            return self.kf.setImage(
                with: provider,
                placeholder: placeholder,
                options: options,
                progressBlock: progressBlock,
                completionHandler: completionHandler
            )
        } else {
            // return image else
            return self.kf.setImage(
                with: URL(string: url ?? ""),
                placeholder: placeholder,
                options: options,
                progressBlock: progressBlock,
                completionHandler: completionHandler
            )
        }

    }

    func deleteImageCache(url: String) {
        ImageCache.default.removeImage(forKey: url)
    }
}
