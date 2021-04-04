/**
 * Model Alerts
 */

struct UsersPolicy {
    var preference: Bool

    init(
        preference: Bool = false
    ) {
        self.preference = preference
    }
}

extension UsersPolicy: Codable, Hashable {
    enum UsersPolicyCodingKeys: String, CodingKey {
        case preference
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UsersPolicyCodingKeys.self)

        preference = try container.decode(Bool.self, forKey: .preference)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UsersPolicyCodingKeys.self)

        try container.encode(preference, forKey: .preference)
    }
}
