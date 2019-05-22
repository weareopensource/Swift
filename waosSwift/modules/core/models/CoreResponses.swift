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
