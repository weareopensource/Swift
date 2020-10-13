/**
 * Dependencies
 */

import Moya

/**
 * Api
 */

enum HomeApi {
    case changelogs
}

extension HomeApi: TargetType {

    public var baseURL: URL {
        return getUrl(_protocol: config["api"]["protocol"].string ?? "http",
                      _host: config["api"]["host"].string ?? "localhost",
                      _port: config["api"]["port"].string ?? "3000",
                      _path: config["api"]["endPoints"]["basePath"].string ?? "api")
    }

    var path: String {
        let apiPathTasks = config["api"]["endPoints"]["home"].string ?? "home"

        switch self {
        case .changelogs:
            return "/" + apiPathTasks + "/changelogs"
        }
    }

    var method: Moya.Method {
        switch self {
        case .changelogs:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .changelogs: return stubbed("changelogs")
        }
    }

    var task: Task {
        switch self {
        case .changelogs:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
