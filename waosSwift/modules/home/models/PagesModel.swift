/**
 * Model Tasks
 */

struct Pages {
    var title: String
    var markdown: String
    var updatedAt: String?

    init(title: String = "", markdown: String = "", updatedAt: String? = "") {
        self.title = title
        self.markdown = markdown
        self.updatedAt = updatedAt
    }
}

extension Pages: Hashable, Codable {
    enum PagesCodingKeys: String, CodingKey {
        case title
        case markdown
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PagesCodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        markdown = try container.decode(String.self, forKey: .markdown)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
