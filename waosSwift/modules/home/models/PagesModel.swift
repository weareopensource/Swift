/**
 * Model Tasks
 */

struct Pages {
    var title: String
    var markdown: String

    init(title: String = "", markdown: String = "") {
        self.title = title
        self.markdown = markdown
    }
}

extension Pages: Hashable, Codable {
    enum PagesCodingKeys: String, CodingKey {
        case title
        case markdown
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PagesCodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        markdown = try container.decode(String.self, forKey: .markdown)
    }
}
