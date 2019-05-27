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
        } else if response.statusCode != 200, let jsonObject = try? response.map(NetworkError.self) {
            let networkError = NetworkError(code: jsonObject.code, message: jsonObject.message, description: jsonObject.description, type: "MoyaError", error: jsonObject.error)
            return networkError
        } else if response.statusCode != 200, let stringObject = try? response.mapString() {
            var result = JSON(parseJSON: stringObject)
            let networkError = NetworkError(code: response.statusCode, message: result["message"].string ?? "Undefined", description: result["description"].string ?? "Undefined", type: "MoyaError", error: result["error"].string ?? "Undefined")
            return networkError
        } else {
            let networkError = NetworkError(code: response.statusCode, message: "unknow", description: error.localizedDescription, type: "MoyaError")
            log.warning("🌎 Error -> \(networkError.type ?? "unknow") : \(networkError.message)", file: file, function: function, line: line)
            return networkError
        }
    } else {
        let networkError = NetworkError(code: 0, message: "unknow", type: "MoyaError")
        log.error("🌎 Error -> \(networkError.type ?? "unknow") : \(networkError.message)", file: file, function: function, line: line)
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
    let code: Int
    let message: String
    let description: String?
    let type: String?
    let error: String?

    init(code: Int, message: String, description: String? = "", type: String? = "", error: String? = "") {
        self.code = code
        self.message = message
        self.description = description
        self.type = type
        self.error = error
    }
}

extension NetworkError: Decodable {
    enum NetworkErrorCodingKeys: String, CodingKey {
        case code
        case message
        case description
        case type
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NetworkErrorCodingKeys.self)

        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(String.self, forKey: .type)
        error = try container.decode(String.self, forKey: .error)
    }
}
