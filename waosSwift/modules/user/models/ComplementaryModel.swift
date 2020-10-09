/**
 * Model Complementary
 */

struct Complementary: Equatable {
    var iosDevices: [Devices]?

    init(iosDevices: [Devices]? = nil) {
        self.iosDevices = iosDevices
    }
}

extension Complementary: Codable, Hashable {
    enum ComplementaryCodingKeys: String, CodingKey {
        case iosDevices
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ComplementaryCodingKeys.self)

        iosDevices = try container.decodeIfPresent([Devices].self, forKey: .iosDevices)
    }
}

struct Devices: Equatable {
    var token: String?
    var swift: String?

    init(token: String? = nil, swift: String? = nil) {
        self.token = token
        self.swift = swift
    }
}

extension Devices: Codable, Hashable {
    enum DevicesCodingKeys: String, CodingKey {
        case token
        case swift
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DevicesCodingKeys.self)

        token = try container.decodeIfPresent(String.self, forKey: .token)
        swift = try container.decodeIfPresent(String.self, forKey: .swift)
    }
}
