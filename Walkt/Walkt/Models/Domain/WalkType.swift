import Foundation

// MARK: - Walk Type

/// Classifies a walk by its purpose.
/// Used for filtering, dashboard personalization, and route comparison.
enum WalkType: Int16, CaseIterable, Codable {
    case unknown = 0
    case commute = 1
    case fitness = 2
    case casual = 3

    var displayName: String {
        switch self {
        case .unknown:  return "Walk"
        case .commute:  return "Commute"
        case .fitness:  return "Fitness"
        case .casual:   return "Casual"
        }
    }
}
