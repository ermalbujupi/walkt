import Foundation

// MARK: - User Segment

/// The user's self-selected walking persona.
/// Determines which dashboard sections and features are shown.
enum UserSegment: String, CaseIterable, Codable {
    case commuter = "Commuter"
    case fitness = "Fitness"
    case casual = "Casual"

    var description: String {
        switch self {
        case .commuter: return "Route comparison, time predictions, consistency metrics"
        case .fitness:  return "Performance trends, personal records, improvement graphs"
        case .casual:   return "Achievement badges, streak tracking, motivational stats"
        }
    }
}
