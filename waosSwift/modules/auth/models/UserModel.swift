/**
 * Model User
 */

struct User {
    var id: String
    var firstName: String?
    var lastName: String?
    var email: String
    var roles: [String]
}

extension User: Codable {
    enum UserCodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case roles
    }
}
