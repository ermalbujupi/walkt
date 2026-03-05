import Foundation

// MARK: - Walk Session

/// Domain model representing a single walking workout.
/// Maps from either an HKWorkout (via HealthKit) or a CDWalkSession (via Core Data).
struct WalkSession: Identifiable, Hashable {
    let id: UUID
    let healthKitUUID: UUID
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval          // seconds
    let totalDistanceMeters: Double
    let totalEnergyKcal: Double
    let averageSpeedMPS: Double         // meters/second
    let maxSpeedMPS: Double
    let totalSteps: Int
    let elevationGainMeters: Double
    let elevationLossMeters: Double
    let hasRouteData: Bool
    let isIndoor: Bool
    let sourceName: String
    let walkType: WalkType

    // MARK: - Computed Properties

    /// Distance in kilometers.
    var distanceKm: Double {
        totalDistanceMeters / 1000.0
    }

    /// Average speed in km/h.
    var averageSpeedKmh: Double {
        averageSpeedMPS * 3.6
    }

    /// Average pace in seconds per kilometer.
    var paceSecondsPerKm: Double {
        guard totalDistanceMeters > 0 else { return 0 }
        return duration / (totalDistanceMeters / 1000.0)
    }

    /// Formatted pace string (e.g. "8:30 /km").
    var formattedPace: String {
        let pace = paceSecondsPerKm
        guard pace > 0, pace.isFinite else { return "--:-- /km" }
        let minutes = Int(pace) / 60
        let seconds = Int(pace) % 60
        return String(format: "%d:%02d /km", minutes, seconds)
    }

    /// Formatted duration string (e.g. "32:15").
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
}
