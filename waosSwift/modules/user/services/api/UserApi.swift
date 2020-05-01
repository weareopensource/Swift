/**
 * Dependencies
 */

import Moya

/**
 * Api
 */

enum UserApi {
    case me
    case update(firstName: String, lastName: String, email: String)
    case delete
    case data
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
        case .me :
            return "/" + apiPathUser + "/me"
        case .update :
            return "/" + apiPathUser
        case .delete :
            return "/" + apiPathUser + "/data"
        case .data :
            return "/" + apiPathUser + "/data/mail"
        }
    }

    var method: Moya.Method {
        switch self {
        case .me:
            return .get
        case .update:
            return .put
        case .delete:
            return .delete
        case .data:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .me: return stubbed("me")
        case .update: return stubbed("update")
        case .delete: return stubbed("delete")
        case .data: return stubbed("data")
        }
    }

    var task: Task {
        switch self {
        case .me, .delete, .data:
            return .requestPlain
        case .update(let firstName, let lastName, let email):
            return .requestParameters(parameters: ["firstName": firstName, "lastName": lastName, "email": email], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
