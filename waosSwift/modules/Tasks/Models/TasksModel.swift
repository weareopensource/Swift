import Foundation

struct Task {

    var id: String
    var title: String
    var description: String?

    init(id: String, title: String, description: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let title = dictionary["title"] as? String
            else { return nil }

        self.id = id
        self.title = title
        self.description = dictionary["description"] as? String
    }

    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": self.id,
            "title": self.title
        ]
        if let description = self.description {
            dictionary["description"] = description
        }
        return dictionary
    }

}
