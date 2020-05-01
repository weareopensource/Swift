/**
 * Model Delete Response
 */

struct DeleteResponse {
    var data: Delete
}
extension DeleteResponse: Codable {
    enum DeleteResponseCodingKeys: String, CodingKey {
        case data
    }
}

/**
* Model Delete Data Response
*/

struct DeleteDataResponse {
    var data: DeleteData
}
extension DeleteDataResponse: Codable {
    enum DeleteDataResponseCodingKeys: String, CodingKey {
        case data
    }
}

/**
* Model Mail Response
*/

struct MailResponse {
    var data: Mail
}
extension MailResponse: Codable {
    enum MailResponseCodingKeys: String, CodingKey {
        case Mail
    }
}
