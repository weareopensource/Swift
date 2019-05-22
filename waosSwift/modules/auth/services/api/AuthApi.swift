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
}

extension AuthApi: TargetType {

    public var baseURL: URL {
        guard let url = URL(string: "http://localhost:3000/api") else { fatalError("baseUrl could not be configured." ) }
        return url
    }

    var path: String {
        switch self {
        case .signin :
            return "/auth/signin"
        case .me :
            return "/users/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signin:
            return .post
        case .me:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .signin: return stubbed("signin")
        case .me: return stubbed("me")
        }
    }

    var task: Task {
        switch self {
        case .signin(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .me:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
