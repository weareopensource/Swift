/**
 * Model Complementary
 */

struct Complementary: Equatable {
    var instagram: String?

    init(instagram: String? = nil) {
        self.instagram = instagram
    }
}

extension Complementary: Codable, Hashable {
    enum ComplementaryCodingKeys: String, CodingKey {
        case instagram
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ComplementaryCodingKeys.self)

        instagram = try container.decodeIfPresent(String.self, forKey: .instagram)
    }
}
