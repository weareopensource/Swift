import Moya
import Result

struct CookiePlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        // print("TURLUTUTU prepare \(CookieStorager.cookie)")
        if let cookie = CookieStorager.cookie as? String {
            request.addValue(cookie, forHTTPHeaderField: "Cookie")
        }
        // print("TURLUTUTU prepare2 \(request.allHTTPHeaderFields)")
        return request
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        // print("TURLUTUTU didReceive")

        switch result {
        case .success(let response):
            // print("TURLUTUTU success")
            guard let response = response.response else {
                return
            }
            _ = CookieStorager.save(httpReq: response)
        case .failure:
            // print("TURLUTUTU error")
            return
        }
    }
}

private let COOKIE = "Cookie"
private let SETCOOKIE = "Set-Cookie"
struct CookieStorager {
    static var cookie: Any? {
        if let cookieStr = UserDefaults.standard.value(forKey: COOKIE) {
            return cookieStr
        } else {
            return nil
        }
    }

    static func save(httpReq: HTTPURLResponse) -> Bool {
        // print("TURLUTUTU")
        guard let cookie = httpReq.allHeaderFields[SETCOOKIE] else {
            return false
        }
        UserDefaults.standard.set(cookie, forKey: COOKIE)
        UserDefaults.standard.synchronize()
        return true
    }
}
