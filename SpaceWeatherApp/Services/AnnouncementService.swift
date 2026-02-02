import Foundation

/// Fetches remote announcements from the Sol GitHub repository
actor AnnouncementService {
    private let session: URLSession
    private let decoder: JSONDecoder

    private static let announcementURL = "https://raw.githubusercontent.com/griffin-goodwin/Sol/main/announcement.json"
    private static let dismissedIDsKey = "dismissedAnnouncementIDs"

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        self.session = URLSession(configuration: config)
        self.decoder = JSONDecoder()
    }

    /// Fetches the current announcement, returning nil if inactive, already dismissed, or on failure.
    func fetchAnnouncement() async -> Announcement? {
        print("[Announcement] Fetching from: \(Self.announcementURL)")
        guard let url = URL(string: Self.announcementURL) else {
            print("[Announcement] Invalid URL")
            return nil
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("[Announcement] Response is not HTTP")
                return nil
            }
            print("[Announcement] HTTP status: \(httpResponse.statusCode)")

            guard httpResponse.statusCode == 200 else {
                return nil
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("[Announcement] Raw JSON: \(raw.prefix(500))")
            }

            let announcement = try decoder.decode(Announcement.self, from: data)
            print("[Announcement] Decoded — active: \(announcement.active), id: \(announcement.id)")

            guard announcement.active else {
                print("[Announcement] Skipped — not active")
                return nil
            }
            guard !isDismissed(announcement.id) else {
                print("[Announcement] Skipped — already dismissed")
                return nil
            }

            print("[Announcement] Showing announcement: \(announcement.id)")
            return announcement
        } catch {
            print("[Announcement] Error: \(error)")
            return nil
        }
    }

    /// Persists the announcement ID so the user won't see it again.
    func dismiss(_ id: String) {
        var dismissed = dismissedIDs()
        dismissed.insert(id)
        UserDefaults.standard.set(Array(dismissed), forKey: Self.dismissedIDsKey)
    }

    // MARK: - Private

    private func isDismissed(_ id: String) -> Bool {
        dismissedIDs().contains(id)
    }

    private func dismissedIDs() -> Set<String> {
        let array = UserDefaults.standard.stringArray(forKey: Self.dismissedIDsKey) ?? []
        return Set(array)
    }
}
