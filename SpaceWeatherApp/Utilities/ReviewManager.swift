import StoreKit
import SwiftUI

/// Manages App Store review request timing using Apple's native prompt.
/// Uses session count and time-based conditions to avoid over-prompting.
enum ReviewManager {

    // MARK: - UserDefaults Keys

    private static let appSessionCountKey = "appSessionCount"
    private static let firstLaunchDateKey = "firstLaunchDate"
    private static let lastReviewRequestDateKey = "lastReviewRequestDate"

    // MARK: - Thresholds

    private static let minimumSessions = 5
    private static let minimumDaysSinceFirstLaunch = 14
    private static let minimumDaysBetweenReviewRequests = 120

    // MARK: - Public Methods

    /// Records an app session. Call every time the app becomes active.
    static func recordAppSession() {
        let defaults = UserDefaults.standard

        // Increment session count
        let count = defaults.integer(forKey: appSessionCountKey) + 1
        defaults.set(count, forKey: appSessionCountKey)

        // Set first launch date if not already set
        if defaults.object(forKey: firstLaunchDateKey) == nil {
            defaults.set(Date().timeIntervalSince1970, forKey: firstLaunchDateKey)
        }
    }

    /// Requests a review if engagement conditions are met.
    /// - Parameter requestReview: The `requestReview` action from the SwiftUI environment.
    @MainActor
    static func requestReviewIfAppropriate(using requestReview: RequestReviewAction) {
        let defaults = UserDefaults.standard
        let now = Date().timeIntervalSince1970

        // Check session count
        let sessionCount = defaults.integer(forKey: appSessionCountKey)
        guard sessionCount >= minimumSessions else { return }

        // Check days since first launch
        let firstLaunch = defaults.double(forKey: firstLaunchDateKey)
        let daysSinceFirstLaunch = (now - firstLaunch) / 86400
        guard daysSinceFirstLaunch >= Double(minimumDaysSinceFirstLaunch) else { return }

        // Check days since last review request
        let lastRequest = defaults.double(forKey: lastReviewRequestDateKey)
        if lastRequest > 0 {
            let daysSinceLastRequest = (now - lastRequest) / 86400
            guard daysSinceLastRequest >= Double(minimumDaysBetweenReviewRequests) else { return }
        }

        // All conditions met — record timestamp and request review
        defaults.set(now, forKey: lastReviewRequestDateKey)
        requestReview()
    }
}
