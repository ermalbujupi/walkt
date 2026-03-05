import Foundation
import HealthKit
import CoreLocation
import Combine

// MARK: - HealthKitManager Combine Extensions

/// Adds Combine publisher wrappers around the completion-handler API
/// for convenient use in view models.
extension HealthKitManager {

    /// Publisher wrapper for requestAuthorization.
    func requestAuthorizationPublisher() -> AnyPublisher<Bool, Error> {
        Future<Bool, Error> { [weak self] promise in
            self?.requestAuthorization { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }

    /// Publisher wrapper for queryWalkingWorkouts.
    func walkingWorkoutsPublisher(
        from startDate: Date,
        to endDate: Date
    ) -> AnyPublisher<[HKWorkout], Error> {
        Future<[HKWorkout], Error> { [weak self] promise in
            self?.queryWalkingWorkouts(from: startDate, to: endDate) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }

    /// Publisher wrapper for queryRouteData.
    func routeDataPublisher(
        for workout: HKWorkout
    ) -> AnyPublisher<[CLLocation], Error> {
        Future<[CLLocation], Error> { [weak self] promise in
            self?.queryRouteData(for: workout) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }

    /// Publisher wrapper for queryStepCount.
    func stepCountPublisher(
        for workout: HKWorkout
    ) -> AnyPublisher<Int, Error> {
        Future<Int, Error> { [weak self] promise in
            self?.queryStepCount(for: workout) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }

    /// Publisher wrapper for queryElevation.
    func elevationPublisher(
        for workout: HKWorkout
    ) -> AnyPublisher<(gain: Double, loss: Double), Error> {
        Future<(gain: Double, loss: Double), Error> { [weak self] promise in
            self?.queryElevation(for: workout) { result in
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}
