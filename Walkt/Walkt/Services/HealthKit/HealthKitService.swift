import Foundation
import HealthKit
import CoreLocation
import Combine

// MARK: - HealthKit Service

/// Concrete implementation of HealthKitManager using HKHealthStore.
/// Handles authorization, workout queries, route extraction,
/// and supplementary metric queries (steps, elevation).
final class HealthKitService: HealthKitManager {

    // MARK: - Properties

    private let healthStore: HKHealthStore
    private let authorizationStatusSubject = CurrentValueSubject<Bool, Never>(false)

    var authorizationStatusPublisher: AnyPublisher<Bool, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }

    /// The set of HealthKit data types this app reads.
    private var readTypes: Set<HKObjectType> {
        let types: [HKObjectType?] = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .stepCount),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            HKObjectType.quantityType(forIdentifier: .flightsClimbed),
            HKSeriesType.workoutRoute()
        ]
        return Set(types.compactMap { $0 })
    }

    // MARK: - Initialization

    init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
    }

    // MARK: - Availability

    func isHealthDataAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    // MARK: - Authorization

    func requestAuthorization(completion: @escaping (Result<Bool, Error>) -> Void) {
        guard isHealthDataAvailable() else {
            completion(.failure(HealthKitServiceError.healthDataNotAvailable))
            return
        }

        healthStore.requestAuthorization(
            toShare: nil,
            read: readTypes
        ) { [weak self] success, error in
            if let error {
                completion(.failure(error))
                return
            }
            self?.authorizationStatusSubject.send(success)
            completion(.success(success))
        }
    }

    // MARK: - Query Walking Workouts

    func queryWalkingWorkouts(
        from startDate: Date,
        to endDate: Date,
        completion: @escaping (Result<[HKWorkout], Error>) -> Void
    ) {
        let datePredicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        let walkingPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [datePredicate, walkingPredicate]
        )

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )

        let query = HKSampleQuery(
            sampleType: HKObjectType.workoutType(),
            predicate: compoundPredicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, error in
            if let error {
                completion(.failure(error))
                return
            }
            let workouts = (samples as? [HKWorkout]) ?? []
            completion(.success(workouts))
        }

        healthStore.execute(query)
    }

    // MARK: - Query Route Data

    func queryRouteData(
        for workout: HKWorkout,
        completion: @escaping (Result<[CLLocation], Error>) -> Void
    ) {
        let routeType = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: workout)

        let routeQuery = HKSampleQuery(
            sampleType: routeType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { [weak self] _, samples, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let routes = samples as? [HKWorkoutRoute],
                  let firstRoute = routes.first else {
                completion(.success([]))
                return
            }

            self?.extractLocations(from: firstRoute, completion: completion)
        }

        healthStore.execute(routeQuery)
    }

    /// Extracts all CLLocation points from an HKWorkoutRoute.
    /// The route query delivers locations in batches; this method accumulates them all.
    private func extractLocations(
        from route: HKWorkoutRoute,
        completion: @escaping (Result<[CLLocation], Error>) -> Void
    ) {
        var allLocations: [CLLocation] = []

        let routeQuery = HKWorkoutRouteQuery(route: route) { _, locations, done, error in
            if let error {
                completion(.failure(error))
                return
            }

            if let locations {
                allLocations.append(contentsOf: locations)
            }

            if done {
                completion(.success(allLocations))
            }
        }

        healthStore.execute(routeQuery)
    }

    // MARK: - Query Step Count

    func queryStepCount(
        for workout: HKWorkout,
        completion: @escaping (Result<Int, Error>) -> Void
    ) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(.failure(HealthKitServiceError.quantityTypeNotAvailable))
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: workout.startDate,
            end: workout.endDate,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, statistics, error in
            if let error {
                completion(.failure(error))
                return
            }
            let steps = statistics?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            completion(.success(Int(steps)))
        }

        healthStore.execute(query)
    }

    // MARK: - Query Elevation

    func queryElevation(
        for workout: HKWorkout,
        completion: @escaping (Result<(gain: Double, loss: Double), Error>) -> Void
    ) {
        // Use workout metadata for elevation if available (iOS 16+)
        if let elevationAscended = workout.metadata?[HKMetadataKeyElevationAscended] as? HKQuantity,
           let elevationDescended = workout.metadata?[HKMetadataKeyElevationDescended] as? HKQuantity {
            let gain = elevationAscended.doubleValue(for: .meter())
            let loss = elevationDescended.doubleValue(for: .meter())
            completion(.success((gain: gain, loss: loss)))
            return
        }

        // Fallback: approximate from flights climbed (1 flight ~ 3 meters)
        guard let flightsType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else {
            completion(.success((gain: 0, loss: 0)))
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: workout.startDate,
            end: workout.endDate,
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: flightsType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, statistics, error in
            if let error {
                completion(.failure(error))
                return
            }
            let flights = statistics?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let estimatedGain = flights * 3.0
            completion(.success((gain: estimatedGain, loss: 0)))
        }

        healthStore.execute(query)
    }
}
