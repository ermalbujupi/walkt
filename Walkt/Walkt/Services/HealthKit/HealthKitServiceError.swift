import Foundation

// MARK: - HealthKit Service Error

/// Errors specific to the HealthKit service layer.
enum HealthKitServiceError: LocalizedError {
    case healthDataNotAvailable
    case quantityTypeNotAvailable
    case authorizationDenied
    case workoutNotFound

    var errorDescription: String? {
        switch self {
        case .healthDataNotAvailable:
            return "Health data is not available on this device."
        case .quantityTypeNotAvailable:
            return "The requested health data type is not available."
        case .authorizationDenied:
            return "Access to health data was denied. Please enable access in Settings."
        case .workoutNotFound:
            return "The requested workout could not be found."
        }
    }
}
