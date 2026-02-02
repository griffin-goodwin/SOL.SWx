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
        guard let url = URL(string: Self.announcementURL) else { return nil }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return nil
            }

            let announcement = try decoder.decode(Announcement.self, from: data)

            guard announcement.active else { return nil }
            guard !isDismissed(announcement.id) else { return nil }

            return announcement
        } catch {
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
