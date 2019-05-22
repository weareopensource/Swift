/**
 * Model Delete
 */

struct Delete {
    var id: String
    var deletedCount: Int
}

extension Delete: Codable {
    enum DeleteCodingKeys: String, CodingKey {
        case id
        case deletedCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeleteCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        deletedCount = try container.decode(Int.self, forKey: .deletedCount)
    }
}
