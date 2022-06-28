/**
 * Dependencies
 */

import UIKit
import Moya
import KeychainAccess
import Kingfisher

let keychain = Keychain(service: config["app"]["service"].string ?? "localhost").synchronizable(true)

/**
 *  Moya Plugin
 */

struct CookiePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let cookie = CookieStorager.cookie as? String {
            request.addValue(cookie, forHTTPHeaderField: "Cookie")
        }
        return request
    }

    func didReceive(_ result: Swift.Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            guard let response = response.response else {
                return
            }
            _ = CookieStorager.save(httpReq: response)
        case .failure:
            return
        }
    }
}

struct CookieStorager {
    static var cookie: Any? {
        do {
            return try keychain.get("Cookie")
        } catch let error {
            print(error)
            return nil
        }
    }

    static func save(httpReq: HTTPURLResponse) -> Bool {
        guard let cookie = httpReq.allHeaderFields["Set-Cookie"] as? String else {
            return false
        }
        if(cookie.contains("TOKEN")) {
            do {
                try keychain.set(cookie, key: "Cookie")
            } catch let error {
                print(error)
                return false
            }
        }
        return false
    }
}

/**
*  Kingfisher Modifier
*/

let cookieModifier = AnyModifier { request in
    var request = request
    if let cookie = CookieStorager.cookie as? String {
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
    }
    return request
}
