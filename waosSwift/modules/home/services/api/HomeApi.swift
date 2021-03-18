/**
 * Dependencies
 */

import UIKit
import Moya

/**
 * Api
 */

enum HomeApi {
    case changelogs
    case page(_ name: String)
}

extension HomeApi: TargetType {

    public var baseURL: URL {
        return getUrl(_protocol: config["api"]["protocol"].string ?? "http",
                      _host: config["api"]["host"].string ?? "localhost",
                      _port: config["api"]["port"].string ?? "3000",
                      _path: config["api"]["endPoints"]["basePath"].string ?? "api")
    }

    var path: String {
        let apiPathHome = config["api"]["endPoints"]["home"].string ?? "home"

        switch self {
        case .changelogs:
            return "/" + apiPathHome + "/changelogs"
        case .page(let name):
            return "/" + apiPathHome + "/pages/" + (name )

        }
    }

    var method: Moya.Method {
        switch self {
        case .changelogs:
            return .get
        case .page:
            return .get
        }
    }

    var sampleData: Data {
        switch self {
        case .changelogs: return stubbed("changelogs")
        case .page: return stubbed("getPages")
        }
    }

    var task: Task {
        switch self {
        case .changelogs, .page:
            return .requestPlain

        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
