/**
 * Dependencies
 */

import Moya

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
        if let cookieStr = UserDefaults.standard.value(forKey: "Cookie") {
            return cookieStr
        } else {
            return nil
        }
    }

    static func save(httpReq: HTTPURLResponse) -> Bool {
        guard let cookie = httpReq.allHeaderFields["Set-Cookie"] else {
            return false
        }
        print("CookiePlugin save \(cookie)")
        UserDefaults.standard.set(cookie, forKey: "Cookie")
        UserDefaults.standard.synchronize()
        return true
    }
}
