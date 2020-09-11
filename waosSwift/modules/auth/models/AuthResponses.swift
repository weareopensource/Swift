/**
 * Model Signin Response
 */

struct SignResponse {
    var user: User
    var tokenExpiresIn: Int
}
extension SignResponse: Codable {
    enum SignResponseCodingKeys: String, CodingKey {
        case user
        case tokenExpiresIn
    }
}

/**
 * Model Token Response
 */

struct TokenResponse {
    var user: User
    var tokenExpiresIn: Int
}
extension TokenResponse: Codable {
    enum TokenResponseCodingKeys: String, CodingKey {
        case user
        case tokenExpiresIn
    }
}

/**
 * Model forgot Response
 */

struct Forgot {
    var status: Bool
    init(status: Bool = false) {
        self.status = status
    }
}

extension Forgot: Hashable, Codable {
    enum TasksCodingKeys: String, CodingKey {
        case status
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TasksCodingKeys.self)
        status = try container.decode(Bool.self, forKey: .status)
    }
}

struct ForgotResponse {
    var message: String
}
extension ForgotResponse: Codable {
    enum TasksResponseCodingKeys: String, CodingKey {
        case message
    }
}
