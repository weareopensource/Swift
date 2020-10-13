/**
 * Model Tasks Responses
 */

struct PagesResponse {
    var data: [Pages]
}
extension PagesResponse: Codable {
    enum PagesResponseCodingKeys: String, CodingKey {
        case data
    }
}
