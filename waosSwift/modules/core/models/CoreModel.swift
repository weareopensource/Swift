/**
 * Model Delete
 */

struct Delete {
    var id: String?
    var deletedCount: Int?
    var n: Int?
    var ok: Int?
}

extension Delete: Codable {
    enum DeleteCodingKeys: String, CodingKey {
        case id
        case deletedCount
        case n
        case ok
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeleteCodingKeys.self)

        id = try container.decodeIfPresent(String.self, forKey: .id)
        deletedCount = try container.decodeIfPresent(Int.self, forKey: .deletedCount)
        n = try container.decodeIfPresent(Int.self, forKey: .n)
        ok = try container.decodeIfPresent(Int.self, forKey: .ok)
    }
}

/**
* Model DeleteData
*/

struct DeleteData {
    var user: Delete?
    var tasks: Delete?
    var uploads: Delete?
}

extension DeleteData: Codable {
    enum DeleteDataCodingKeys: String, CodingKey {
        case user
        case tasks
        case uploads
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeleteDataCodingKeys.self)

        user = try container.decodeIfPresent(Delete.self, forKey: .user)
        tasks = try container.decodeIfPresent(Delete.self, forKey: .tasks)
        uploads = try container.decodeIfPresent(Delete.self, forKey: .uploads)
    }
}

/**
* Model Mail
*/

struct Mail {
    var status: Bool
}

extension Mail: Codable {
    enum MailCodingKeys: String, CodingKey {
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MailCodingKeys.self)

        status = try container.decode(Bool.self, forKey: .status)
    }
}
