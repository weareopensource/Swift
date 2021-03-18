/**
 * Dependencies
 */

import UIKit
import Moya
import Validator
import SwiftyJSON

/**
 * extension
 */

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
 * @desc function to generate display error (Tempo used to help homemade errors)
 * @param {CustomError} error
 * @return {DisplayError}
 */
func getDisplayError(_ error: CustomError, _ isLogged: Bool) -> DisplayError {
    let _error: DisplayError
    if error.code == 401 {
        if(isLogged) {
            _error = DisplayError(code: error.code ?? 0, title: "Sign In", description: L10n.popupLogout, type: error.type, source: getRawError(error))
        } else {
            _error = DisplayError(code: error.code ?? 0, title: "Sign In", description: L10n.popupSignfail, type: error.type, source: getRawError(error))
        }
    } else {
        _error = DisplayError(code: error.code ?? 0, title: error.message, description: (error.description ?? "Unknown error"), type: error.type, source: getRawError(error))
    }
    return _error
}

/**
 * @desc function to purge errors on sucess
 * @param {Error} error
 * @return {CustomError}
 */
func purgeErrors(errors: [DisplayError], specificTitles: [String]? = nil) -> [DisplayError] {
    var _errors: [DisplayError] = errors
    if let _titles = specificTitles {
        for title in _titles {
            if let index = _errors.firstIndex(where: { $0.title == title }) {
                _errors.remove(at: index)
            }
        }
    }
    return _errors
}

/**
 * @desc function to purge errors on sucess
 * @param {Error} error
 * @return {CustomError}
 */
func getRawError(_ error: CustomError) -> String? {
    if let jsonData = try? JSONEncoder().encode(error) {
        let jsonString = String(data: jsonData, encoding: .utf8)
        return jsonString
    }
    return nil
}

/**
 * @desc function to format mail error
 * @param {Error} error
 * @return {CustomError}
 */
func setMailError(_ source: String?) -> String {
    return "<body><p>Dear Comes team,</p><p>I found a strange error that I want to report to you: :</p><pre style='background: #f5f2f0; color:#72972c; padding: 15px; border-radius: 7px;'>\(source ?? "")</pre><p>Sincerely, <br/>a loyal user.</o></body>"
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

extension CustomError: Decodable, Encodable {
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

struct DisplayError: Error, Equatable {
    let code: Int
    let title: String
    let description: String
    let type: String?
    let source: String?

    init(code: Int, title: String, description: String?, type: String? = "", source: String?) {
        self.code = code
        self.title = title
        self.description = description ?? "Unknown error"
        self.type = type
        self.source = source
    }

    static func == (lhs: DisplayError, rhs: DisplayError) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description && lhs.code == rhs.code
    }
}
