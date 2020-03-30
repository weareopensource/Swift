//
//  UIImageView+Kingfisher.swift
//  Drrrible
//
//  Created by Suyeol Jeon on 01/05/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//
import UIKit

import Kingfisher
import RxCocoa
import RxSwift

typealias ImageOptions = KingfisherOptionsInfo

enum ImageResult {
    case success(UIImage)
    case failure(Error)

    var image: UIImage? {
        if case .success(let image) = self {
            return image
        } else {
            return nil
        }
    }

    var error: Error? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

enum imageStyle {
    case blured
    case bwBlured
    case animated
}

extension UIImageView {
    @discardableResult
    func setImage(
        url: String?,
        placeholder: UIImage? = nil,
        options: ImageOptions? = nil,
        progress: ((Int64, Int64) -> Void)? = nil,
        completion: ((ImageResult) -> Void)? = nil,
        style: imageStyle? = nil,
        defaultImage: String? = nil // should be a Bundle.main.path image name of type png
    ) -> DownloadTask? {
        var options = options ?? []
        switch style {
        case .animated:
            options = [.cacheSerializer(FormatIndicatedCacheSerializer.gif), .forceRefresh]
        case .blured:
            let processor = OverlayImageProcessor(overlay: .black, fraction: 0.9) |> BlurImageProcessor(blurRadius: 20)
            options = [.processor(processor)]
        case .bwBlured:
            let processor = OverlayImageProcessor(overlay: .black, fraction: 0.85) |> BlurImageProcessor(blurRadius: 20)  |> BlackWhiteProcessor()
            options = [.processor(processor)]
        default:
            options = []
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
                progressBlock: progress
            )
        } else {
            return self.kf.setImage(
                with: URL(string: url ?? ""),
                placeholder: placeholder,
                options: options,
                progressBlock: progress
            )
        }
//        completionHandler: { result in
//            switch result {
//            case .success:
//                // print("Image: \(value.image). Got from: \(value.cacheType)")
//                break
//            case .failure:
//                //case .failure(let error):
//                // log.error("🌄 Error -> \(error)")
//                break
//            }
//        }

    }
}
