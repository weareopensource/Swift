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
    case token
    case forgot(email: String)
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

        switch self {
        case .signUp :
            return "/" + apiPathAuth + "/signup"
        case .signIn :
            return "/" + apiPathAuth + "/signin"
        case .token :
            return "/" + apiPathAuth + "/token"
        case .forgot :
            return "/" + apiPathAuth + "/forgot"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signUp, .signIn, .forgot:
            return .post
        case .token:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .signUp: return stubbed("signup")
        case .signIn: return stubbed("signin")
        case .token: return stubbed("me")
        case .forgot: return stubbed("forgot")
        }
    }

    var task: Task {
        switch self {
        case .signUp(let firstName, let lastName, let email, let password):
            return .requestParameters(parameters: ["firstName": firstName, "lastName": lastName, "email": email, "password": password], encoding: JSONEncoding.default)
        case .signIn(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .token:
            return .requestPlain
        case .forgot(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
