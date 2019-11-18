/**
 * Model Tasks Responses
 */

struct TasksResponse {
    var data: [Tasks]
}
extension TasksResponse: Codable {
    enum TasksResponseCodingKeys: String, CodingKey {
        case data
    }
}

/**
 * Model Task Responses
 */

struct TaskResponse {
    var data: Tasks
}
extension TaskResponse: Codable {
    enum TaskResponseCodingKeys: String, CodingKey {
        case data
    }
}
