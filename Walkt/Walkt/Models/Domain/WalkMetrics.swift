import Foundation

// MARK: - Walk Metrics

/// Raw metrics extracted from an HKWorkout before full session processing.
/// Used as an intermediate representation during HealthKit sync.
struct WalkMetrics {
    let duration: TimeInterval          // seconds
    let totalDistance: Double            // meters
    let totalEnergyBurned: Double       // kcal
    let startDate: Date
    let endDate: Date
    let source: String

    var averageSpeedKmh: Double {
        guard duration > 0 else { return 0 }
        return (totalDistance / 1000.0) / (duration / 3600.0)
    }

    var averageSpeedMPS: Double {
        guard duration > 0 else { return 0 }
        return totalDistance / duration
    }

    var paceSecondsPerKm: Double {
        guard totalDistance > 0 else { return 0 }
        return duration / (totalDistance / 1000.0)
    }
}
