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
 * Model Me Response
 */

struct MeResponse {
    var data: User
}
extension MeResponse: Codable {
    enum MeResponseCodingKeys: String, CodingKey {
        case data
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
