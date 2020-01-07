/**
 * Model Tasks
 */

struct Tasks {
    var id: String?
    var title: String
    var description: String?

    init(title: String = "", description: String? = "") {
        self.title = title
        self.description = description
    }
}

extension Tasks: Hashable, Codable {
    enum TasksCodingKeys: String, CodingKey {
        case id
        case title
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TasksCodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description? = try container.decode(String.self, forKey: .description)
    }
}
