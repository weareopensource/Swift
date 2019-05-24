/**
 * Dependencies
 */

import Moya

/**
 * functions
 */

/**
 * @desc convert moya Error or waos Api error to Network Error model
 * @param {Error} error
 * @return {CustomError}
 */
func getNetworkError(_ error: Error, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> CustomError! {
    if let response = (error as? MoyaError)?.response {
        if let networkError = try? response.map(NetworkError.self) {
            return CustomError.networkError(networkError)
        } else if response.statusCode != 200, let jsonObject = try? response.mapJSON() {
            let networkError = NetworkError(type: "MoyaError", message: "\(response.statusCode) : \(jsonObject)", error: "unknow")
            return CustomError.networkError(networkError)
        } else if response.statusCode != 200, let jsonObject = try? response.mapString() {
            let networkError = NetworkError(type: "MoyaError", message: "\(response.statusCode) : \(jsonObject)", error: "unknow")
            return CustomError.networkError(networkError)
        } else {
            let networkError = NetworkError(type: "MoyaError", message: error.localizedDescription, error: "unknow")
            log.warning("🌎 Error -> \(networkError.type) : \(networkError.message)", file: file, function: function, line: line)
            return CustomError.networkError(networkError)
        }
    } else {
        let networkError = NetworkError(type: "unknow", message: "unknow", error: "unknow")
        log.error("🌎 Error -> \(networkError.type) : \(networkError.message)", file: file, function: function, line: line)
        return CustomError.networkError(networkError)
    }
}

/**
 * Custom Errors
 */

enum CustomError: Swift.Error {
    case networkError(NetworkError)
}

/**
 * Model Network Errors
 */

struct NetworkError {
    var error: String
    var message: String
    var type: String

    init(type: String, message: String, error: String) {
        self.type = type
        self.message = message
        self.error = error
    }
}

extension NetworkError: Decodable {
    enum NetworkErrorCodingKeys: String, CodingKey {
        case type
        case message
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NetworkErrorCodingKeys.self)

        type = try container.decode(String.self, forKey: .type)
        message = try container.decode(String.self, forKey: .message)
        error = try container.decode(String.self, forKey: .error)
    }
}
