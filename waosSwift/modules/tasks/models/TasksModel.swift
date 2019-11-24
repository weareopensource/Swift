/**
 * Model Tasks
 */

struct Tasks {
    var id: String
    var title: String
    var description: String?

    init(id: String = "", title: String = "", description: String? = "") {
        self.id = id
        self.title = title
        self.description = description
    }
}

extension Tasks: Codable {
    enum TasksCodingKeys: String, CodingKey {
        case id
        case title
        case description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TasksCodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description? = try container.decode(String.self, forKey: .description)
    }
}
