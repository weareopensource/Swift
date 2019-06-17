/**
 * Dependencies
 */

import Moya

/**
 * Api
 */

enum AuthApi {
    case signUp(firstName: String, lastName: String, email: String, password: String)
    case signIn(email: String, password: String)
    case me
    case token
}

extension AuthApi: TargetType {

    public var baseURL: URL {
        return getUrl(_protocol: config["api"]["protocol"].string ?? "http",
                      _host: config["api"]["host"].string ?? "localhost",
                      _port: config["api"]["port"].string ?? "3000",
                      _path: config["api"]["endPoints"]["basePath"].string ?? "api")
    }

    var path: String {
        let apiPathAuth = config["api"]["endPoints"]["auth"].string ?? "auth"
        let apiPathUsers = config["api"]["endPoints"]["users"].string ?? "users"

        switch self {
        case .signUp :
            return "/" + apiPathAuth + "/signup"
        case .signIn :
            return "/" + apiPathAuth + "/signin"
        case .token :
            return "/" + apiPathAuth + "/token"
        case .me :
            return "/" + apiPathUsers + "/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp, .signIn:
            return .post
        case .me, .token:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .signUp: return stubbed("signup")
        case .signIn: return stubbed("signin")
        case .me: return stubbed("me")
        case .token: return stubbed("me")
        }
    }

    var task: Task {
        switch self {
        case .signUp(let firstName, let lastName, let email, let password):
            return .requestParameters(parameters: ["firstName": firstName, "lastName": lastName, "email": email, "password": password], encoding: JSONEncoding.default)
        case .signIn(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .me, .token:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
