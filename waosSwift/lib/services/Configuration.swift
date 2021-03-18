/**
 * Dependencies
 */

import UIKit
import SwiftyJSON

/**
 * class
 */

final class Config {

     let global: JSON = {
        // init development config
        let pathDev = Bundle.main.path(forResource: "development", ofType: "json")!
        let jsonStringDev = try? String(contentsOfFile: pathDev, encoding: String.Encoding.utf8)
        var result = JSON(parseJSON: jsonStringDev!)
        if let configuration = Bundle.main.infoDictionary?["Configuration"] as? String {
            if configuration.range(of: "development") != nil {
                return result
            }
        }
        // merge with production config if needed
        let pathProd = Bundle.main.path(forResource: "production", ofType: "json")!
        do {
            let jsonStringProd = try? String(contentsOfFile: pathProd, encoding: String.Encoding.utf8)
            try result.merge(with: JSON(parseJSON: jsonStringProd!))
            result = try result.merged(with: JSON(parseJSON: jsonStringProd!))
        } catch {
            log.error(error)
        }
        if let configuration = Bundle.main.infoDictionary?["Configuration"] as? String {
            if configuration.range(of: "production") != nil {
                return result
            }
        }

        // merge with release config if needed
        let pathRelease = Bundle.main.path(forResource: "release", ofType: "json")!
        do {
            let jsonStringRelease = try? String(contentsOfFile: pathRelease, encoding: String.Encoding.utf8)
            try result.merge(with: JSON(parseJSON: jsonStringRelease!))
            result = try result.merged(with: JSON(parseJSON: jsonStringRelease!))
        } catch {
            log.error(error)
        }
        return result
    }()
}

let config = Config().global
