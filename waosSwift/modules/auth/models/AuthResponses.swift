/**
 * Model Signin Response
 */

struct SignInResponse {
    var user: User
    var tokenExpiresIn: Int
}
extension SignInResponse: Codable {
    enum SignInResponseCodingKeys: String, CodingKey {
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

