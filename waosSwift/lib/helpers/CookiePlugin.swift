/**
 * Dependencies
 */

import Moya
import KeychainAccess

let keychain = Keychain(service: config["service"].string ?? "localhost").synchronizable(true)

/**
 * structs
 */

struct CookiePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let cookie = CookieStorager.cookie as? String {
            request.addValue(cookie, forHTTPHeaderField: "Cookie")
        }
        return request
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
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
        do {
            try keychain.set(cookie, key: "cookie")
            return true
        } catch let error {
            print(error)
            return false
        }
    }
}
