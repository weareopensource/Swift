/**
 * Dependencies
 */

import Moya

/**
 * Api
 */

enum UserApi {
    case me
    case update(_ user: User)
    case delete
    case updateAvatar(file: Data, partName: String, fileName: String, mimeType: String)
    case deleteAvatar
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
        case .updateAvatar :
            return "/" + apiPathUser + "/avatar"
        case .deleteAvatar :
            return "/" + apiPathUser + "/avatar"
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
        case .updateAvatar:
            return .post
        case .deleteAvatar:
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
        case .updateAvatar: return stubbed("avatar")
        case .deleteAvatar: return stubbed("avatar")
        case .data: return stubbed("data")
        }
    }

    var task: Task {
        switch self {
        case .me, .delete, .deleteAvatar, .data:
            return .requestPlain
        case .update(let user):
            return .requestJSONEncodable(user)
        case .updateAvatar(let data, let partName, let fileName, let mimeType):
            let gifData = MultipartFormData(provider: .data(data), name: partName, fileName: fileName, mimeType: mimeType)
            return .uploadMultipart([gifData])
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
