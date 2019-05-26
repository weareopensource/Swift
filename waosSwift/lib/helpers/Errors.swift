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
func getNetworkError(_ error: Error, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> NetworkError! {
    if let response = (error as? MoyaError)?.response {
        if let networkError = try? response.map(NetworkError.self) {
            return networkError
        } else if response.statusCode != 200, let jsonObject = try? response.mapJSON() {
            let networkError = NetworkError(type: "MoyaError", message: "\(jsonObject)", error: "unknow", code: response.statusCode)
            return networkError
        } else if response.statusCode != 200, let jsonObject = try? response.mapString() {
            let networkError = NetworkError(type: "MoyaError", message: "\(jsonObject)", error: "unknow", code: response.statusCode)
            return networkError
        } else {
            let networkError = NetworkError(type: "MoyaError", message: error.localizedDescription, error: "unknow", code: response.statusCode)
            log.warning("🌎 Error -> \(networkError.type) : \(networkError.message)", file: file, function: function, line: line)
            return networkError
        }
    } else {
        let networkError = NetworkError(type: "unknow", message: "unknow", error: "unknow")
        log.error("🌎 Error -> \(networkError.type) : \(networkError.message)", file: file, function: function, line: line)
        return networkError
    }
}

/**
 * Custom Errors
 */

//enum CustomError: Error {
//    case networkError(NetworkError)
//}

/**
 * Model Network Errors
 */

struct NetworkError: Error {
    let error: String
    let message: String
    let type: String
    let code: Int?

    var localizedDescription: String {
        return NSLocalizedString(message, comment: "")
    }

    init(type: String, message: String, error: String, code: Int? = 0) {
        self.type = type
        self.message = message
        self.error = error
        self.code = code
    }
}

extension NetworkError: Decodable {
    enum NetworkErrorCodingKeys: String, CodingKey {
        case type
        case message
        case error
        case code
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NetworkErrorCodingKeys.self)

        type = try container.decode(String.self, forKey: .type)
        message = try container.decode(String.self, forKey: .message)
        error = try container.decode(String.self, forKey: .error)
        code = try container.decode(Int.self, forKey: .code)
    }
}
