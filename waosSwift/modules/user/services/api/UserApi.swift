/**
 * Dependencies
 */

import Moya

/**
 * Api
 */

enum UserApi {
    case update(firstName: String, lastName: String, email: String)
    case delete
    case me
}

extension UserApi: TargetType {

    public var baseURL: URL {
        return getUrl(_protocol: config["api"]["protocol"].string ?? "http",
                      _host: config["api"]["host"].string ?? "localhost",
                      _port: config["api"]["port"].string ?? "3000",
                      _path: config["api"]["endPoints"]["basePath"].string ?? "api")
    }

    var path: String {
        let apiPathUser = config["api"]["endPoints"]["users"].string ?? "users"

        switch self {
        case .update, .delete :
            return "/" + apiPathUser
        case .me :
            return "/" + apiPathUser + "/me"
        }
    }

    var method: Moya.Method {
        switch self {
        case .update:
            return .put
        case .delete:
            return .delete
        case .me:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .update: return stubbed("update")
        case .delete: return stubbed("delete")
        case .me: return stubbed("me")
        }
    }

    var task: Task {
        switch self {
        case .update(let firstName, let lastName, let email):
            return .requestParameters(parameters: ["firstName": firstName, "lastName": lastName, "email": email], encoding: JSONEncoding.default)
        case .me, .delete:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
