import Foundation
import HealthKit
import CoreLocation
import Combine

// MARK: - HealthKit Manager Protocol

/// Defines the interface for all HealthKit interactions.
/// Protocol-based for testability; a mock can be injected in tests
/// without requiring HealthKit entitlements or a physical device.
protocol HealthKitManager: AnyObject {

    /// Whether HealthKit is available on this device.
    func isHealthDataAvailable() -> Bool

    /// Requests read authorization for walking-related data types.
    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void)

    /// Queries walking workouts within a date range.
    func queryWalkingWorkouts(
        from startDate: Date,
        to endDate: Date,
        completion: @escaping (Result<[HKWorkout], Error>) -> Void
    )

    /// Extracts GPS route data from a workout's associated HKWorkoutRoute.
    func queryRouteData(
        for workout: HKWorkout,
        completion: @escaping (Result<[CLLocation], Error>) -> Void
    )

    /// Queries the total step count during a workout's time interval.
    func queryStepCount(
        for workout: HKWorkout,
        completion: @escaping (Result<Int, Error>) -> Void
    )

    /// Queries elevation gain and loss during a workout's time interval.
    func queryElevation(
        for workout: HKWorkout,
        completion: @escaping (Result<(gain: Double, loss: Double), Error>) -> Void
    )

    /// Publisher that emits authorization status changes.
    var authorizationStatusPublisher: AnyPublisher<Bool, Never> { get }
}
