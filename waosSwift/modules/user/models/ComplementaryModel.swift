/**
 * Model Complementary
 */

struct Complementary: Equatable {
    var iosDevices: [Devices]?
    var socialNetworks: SocialNetworks?

    init(iosDevices: [Devices]? = nil, socialNetworks: SocialNetworks? = nil) {
        self.iosDevices = iosDevices
        self.socialNetworks = socialNetworks
    }
}

extension Complementary: Codable, Hashable {
    enum ComplementaryCodingKeys: String, CodingKey {
        case iosDevices
        case socialNetworks
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ComplementaryCodingKeys.self)

        iosDevices = try container.decodeIfPresent([Devices].self, forKey: .iosDevices)
        socialNetworks = try container.decodeIfPresent(SocialNetworks.self, forKey: .socialNetworks)
    }
}

/**
 * Model SocialNetworks
 */

struct SocialNetworks: Equatable {
    var instagram: String?
    var twitter: String?
    var facebook: String?

    init(instagram: String? = nil, twitter: String? = nil, facebook: String? = nil) {
        self.instagram = instagram
        self.twitter = twitter
        self.facebook = facebook
    }
}

extension SocialNetworks: Codable, Hashable {
    enum SocialNetworksCodingKeys: String, CodingKey {
        case instagram
        case twitter
        case facebook
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SocialNetworksCodingKeys.self)

        instagram = try container.decodeIfPresent(String.self, forKey: .instagram)
        twitter = try container.decodeIfPresent(String.self, forKey: .twitter)
        facebook = try container.decodeIfPresent(String.self, forKey: .facebook)
    }
}

/**
 * Model Devices
 */

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
