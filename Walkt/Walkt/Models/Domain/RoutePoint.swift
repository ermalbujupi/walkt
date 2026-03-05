import Foundation

// MARK: - Route Point

/// A single GPS coordinate along a walking route.
/// Extracted from HKWorkoutRoute via HKWorkoutRouteQuery.
struct RoutePoint: Identifiable, Hashable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let altitude: Double           // meters
    let speed: Double              // meters/second, -1 if invalid
    let timestamp: Date
    let horizontalAccuracy: Double // meters, lower is better
    let sortOrder: Int

    /// Whether the speed value is valid (GPS was able to determine it).
    var hasValidSpeed: Bool {
        speed >= 0
    }

    /// Speed in km/h, or nil if invalid.
    var speedKmh: Double? {
        guard hasValidSpeed else { return nil }
        return speed * 3.6
    }
}
