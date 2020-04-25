/**
 * Dependencies
 */

import Moya
import Validator

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

/**
 * functions
 */

/**
 * @desc convert moya Error or waos Api error to Network Error model
 * @param {Error} error
 * @return {CustomError}
 */
func getError(_ error: Error, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> CustomError! {
    if let response = (error as? MoyaError)?.response {
        if let networkError = try? response.map(CustomError.self) {
            return networkError
        } else if response.statusCode != 200, let jsonObject = try? response.map(CustomError.self) {
            let networkError = CustomError(code: jsonObject.code, message: jsonObject.message, description: jsonObject.description, type: "MoyaError", error: jsonObject.error)
            return networkError
        } else if response.statusCode != 200, let stringObject = try? response.mapString() {
            let result = JSON(parseJSON: stringObject)
            let networkError = CustomError(code: response.statusCode, message: result["message"].string ?? "Undefined", description: result["description"].string ?? "Undefined", type: "MoyaError", error: result["error"].string ?? "Undefined")
            return networkError
        } else {
            let networkError = CustomError(code: response.statusCode, message: "unknow", description: error.localizedDescription, type: "MoyaError")
            log.warning("🌎 Error -> \(networkError.type ?? "unknow") : \(networkError.message)", file: file, function: function, line: line)
            return networkError
        }
    } else {
        let networkError = CustomError(code: 0, message: "unknow", description: "Oops service unavailable, please try again in few minutes.", type: "CustomError")
        log.error("🌎 Error -> \(networkError.type ?? "unknow") : \(networkError.message)", file: file, function: function, line: line)
        return networkError
    }
}

/**
 * @desc function to purge errors on sucess
 * @param {Error} error
 * @return {CustomError}
 */
func purgeErrors(errors: [DisplayError], titles: [String]) -> [DisplayError] {
    var _error: [DisplayError] = errors
    for title in titles {
        if let index = _error.firstIndex(where: { $0.title == title }) {
            _error.remove(at: index)
        }
    }
    return _error
}

/**
 * Custom Errors
 */

//enum CustomError: Error {
//    case networkError(CustomError)
//}

/**
 * Model Network Errors
 */

struct CustomError: Error, ValidationError {
    let code: Int?
    let message: String
    let description: String?
    let type: String?
    let error: String?

    init(code: Int? = 0, message: String, description: String? = "", type: String? = "", error: String? = "") {
        self.code = code
        self.message = message
        self.description = description
        self.type = type
        self.error = error
    }
}

extension CustomError: Decodable {
    enum CustomErrorCodingKeys: String, CodingKey {
        case code
        case message
        case description
        case type
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomErrorCodingKeys.self)

        code = try container.decode(Int.self, forKey: .code)
        message = try container.decode(String.self, forKey: .message)
        description = try container.decode(String.self, forKey: .description)
        type = try container.decode(String.self, forKey: .type)
        error = try container.decode(String.self, forKey: .error)
    }
}

struct DisplayError: Error {
    let title: String
    let description: String

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
