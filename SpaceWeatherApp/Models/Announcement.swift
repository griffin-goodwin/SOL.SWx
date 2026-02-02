import Foundation

/// Remote announcement fetched from GitHub for in-app notices
struct Announcement: Codable, Sendable {
    let active: Bool
    let id: String
    let title: String
    let message: String
    let linkURL: String?
    let linkLabel: String?
    let type: AnnouncementType

    enum AnnouncementType: String, Codable, Sendable {
        case info
        case warning
        case critical
        case success
    }
}
