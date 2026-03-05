import Foundation

// MARK: - Speed Segment

/// A contiguous section of a route where the walker maintained a similar speed category.
/// Used for speed zone breakdown on the walk detail screen.
struct SpeedSegment: Identifiable, Hashable {
    let id: UUID
    let startIndex: Int                 // index into route points array
    let endIndex: Int
    let category: SpeedCategory
    let averageSpeed: Double            // meters/second
    let distance: Double                // meters
    let duration: TimeInterval          // seconds
}

// MARK: - Speed Category

/// Walking speed classification based on km/h thresholds.
enum SpeedCategory: String, CaseIterable, Codable {
    case slow = "Slow"              // < 3.5 km/h
    case moderate = "Moderate"      // 3.5 - 5.5 km/h
    case brisk = "Brisk"            // 5.5 - 7.0 km/h
    case fast = "Fast"              // > 7.0 km/h

    /// Classify a speed in meters/second into a category.
    static func from(speedMPS: Double) -> SpeedCategory {
        let kmh = speedMPS * 3.6
        switch kmh {
        case ..<3.5:    return .slow
        case 3.5..<5.5: return .moderate
        case 5.5..<7.0: return .brisk
        default:        return .fast
        }
    }
}
