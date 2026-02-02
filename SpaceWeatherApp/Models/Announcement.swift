import Foundation

/// Remote announcement fetched from GitHub for in-app notices
struct Announcement: Codable, Sendable, Identifiable {
    let active: Bool
    let id: String
    let title: String
    let message: String
    let linkURL: String?
    let linkLabel: String?
    let type: AnnouncementType
    let persistent: Bool

    enum AnnouncementType: String, Codable, Sendable {
        case info
        case warning
        case critical
        case success
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        active = try container.decode(Bool.self, forKey: .active)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        message = try container.decode(String.self, forKey: .message)
        linkURL = try container.decodeIfPresent(String.self, forKey: .linkURL)
        linkLabel = try container.decodeIfPresent(String.self, forKey: .linkLabel)
        type = try container.decode(AnnouncementType.self, forKey: .type)
        persistent = try container.decodeIfPresent(Bool.self, forKey: .persistent) ?? false
    }
}
