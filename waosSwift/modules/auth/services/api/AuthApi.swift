/**
 * Dependencies
 */

import Moya

/**
 * Api
 */

enum AuthApi {
    case signin(email: String, password: String)
    case me
    case token
}

extension AuthApi: TargetType {

    public var baseURL: URL {
        let ApiProtocol = config["api"]["protocol"].string ?? "http"
        let ApiHost = config["api"]["host"].string ?? "localhost"
        let ApiPort = config["api"]["port"].string ?? "3000"
        let ApiBasePath = config["api"]["endPoints"]["basePath"].string ?? "api"

        guard let url = URL(string: ApiProtocol + "://" + ApiHost + ":" + ApiPort + "/" + ApiBasePath) else { fatalError("baseUrl could not be configured." ) }
        return url
    }

    var path: String {
        let ApiPathAuth = config["api"]["endPoints"]["auth"].string ?? "auth"
        let ApiPathUsers = config["api"]["endPoints"]["users"].string ?? "users"

        switch self {
        case .signin :
            return "/" + ApiPathAuth + "/signin"
        case .token :
            return "/" + ApiPathAuth + "/token"
        case .me :
            return "/" + ApiPathUsers + "/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signin:
            return .post
        case .me:
            return .get
        case .token:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .signin: return stubbed("signin")
        case .me: return stubbed("me")
        case .token: return stubbed("me")
        }
    }

    var task: Task {
        switch self {
        case .signin(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .me, .token:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
