/**
 * Dependencies
 */

import UIKit
import Moya

/**
 * Api
 */

enum TasksApi {
    case list
    case create(_ task: Tasks)
    case get(_ task: Tasks)
    case update(_ task: Tasks)
    case delete(_ task: Tasks)

}

extension TasksApi: TargetType {

    public var baseURL: URL {
        return getUrl(_protocol: config["api"]["protocol"].string ?? "http",
                      _host: config["api"]["host"].string ?? "localhost",
                      _port: config["api"]["port"].string ?? "3000",
                      _path: config["api"]["endPoints"]["basePath"].string ?? "api")
    }

    var path: String {
        let apiPathTasks = config["api"]["endPoints"]["tasks"].string ?? "tasks"

        switch self {
        case .list, .create:
            return "/" + apiPathTasks
        case .get(let task), .update(let task), .delete(let task):
            return "/" + apiPathTasks + "/" + (task.id ?? "")
        }
    }

    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .create:
            return .post
        case .get:
            return .get
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var sampleData: Data {
        switch self {
        case .list: return stubbed("list")
        case .create: return stubbed("create")
        case .get: return stubbed("get")
        case .update: return stubbed("update")
        case .delete: return stubbed("delete")
        }
    }

    var task: Task {
        switch self {
        case .list, .get, .delete:
            return .requestPlain

        case .create(let task), .update(let task):
            return .requestJSONEncodable(task)
            // return .requestParameters(parameters: ["title": task.title, "description": task.description ?? ""], encoding: JSONEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
