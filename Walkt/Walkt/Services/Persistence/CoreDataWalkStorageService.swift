import Foundation
import CoreData
import Combine

// MARK: - Core Data Walk Storage Service

/// Concrete implementation of WalkStorageService backed by Core Data.
final class CoreDataWalkStorageService: WalkStorageService {

    // MARK: - Properties

    private let persistenceController: PersistenceController
    let sessionsDidChange = PassthroughSubject<Void, Never>()

    // MARK: - Initialization

    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    // MARK: - Save

    func save(walkSession session: WalkSession, routePoints: [RoutePoint]) throws {
        let context = persistenceController.viewContext

        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
        fetchRequest.fetchLimit = 1

        let existing = try context.fetch(fetchRequest).first

        let cdSession: CDWalkSession
        if let existing {
            cdSession = existing
            if let oldPoints = cdSession.routePoints {
                for case let point as NSManagedObject in oldPoints {
                    context.delete(point)
                }
            }
        } else {
            cdSession = CDWalkSession(context: context)
        }

        cdSession.update(from: session)

        let mutableRoutePoints = cdSession.mutableOrderedSetValue(forKey: "routePoints")
        for point in routePoints {
            let cdPoint = CDRoutePoint(context: context)
            cdPoint.update(from: point)
            cdPoint.walkSession = cdSession
            mutableRoutePoints.add(cdPoint)
        }

        try context.save()
        sessionsDidChange.send()
    }

    // MARK: - Fetch All

    func fetchAll() throws -> [WalkSession] {
        let context = persistenceController.viewContext
        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: false)
        ]

        return try context.fetch(fetchRequest).map { $0.toDomain() }
    }

    // MARK: - Fetch By ID

    func fetch(byId id: UUID) throws -> WalkSession? {
        let context = persistenceController.viewContext
        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        return try context.fetch(fetchRequest).first?.toDomain()
    }

    // MARK: - Fetch Sessions By Date Range

    func fetchSessions(from startDate: Date, to endDate: Date) throws -> [WalkSession] {
        let context = persistenceController.viewContext
        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "startDate >= %@ AND startDate <= %@",
            startDate as NSDate,
            endDate as NSDate
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startDate", ascending: false)
        ]

        return try context.fetch(fetchRequest).map { $0.toDomain() }
    }

    // MARK: - Fetch Route Points

    func fetchRoutePoints(for walkSessionId: UUID) throws -> [RoutePoint] {
        let context = persistenceController.viewContext
        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", walkSessionId as CVarArg)
        fetchRequest.fetchLimit = 1

        guard let cdSession = try context.fetch(fetchRequest).first,
              let orderedSet = cdSession.routePoints else {
            return []
        }

        return orderedSet.compactMap { ($0 as? CDRoutePoint)?.toDomain() }
    }

    // MARK: - Delete

    func delete(walkSessionId: UUID) throws {
        let context = persistenceController.viewContext
        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", walkSessionId as CVarArg)
        fetchRequest.fetchLimit = 1

        guard let cdSession = try context.fetch(fetchRequest).first else { return }

        context.delete(cdSession)
        try context.save()
        sessionsDidChange.send()
    }

    // MARK: - Exists (Deduplication)

    func exists(healthKitUUID: UUID) throws -> Bool {
        let context = persistenceController.viewContext
        let fetchRequest = CDWalkSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "healthKitUUID == %@",
            healthKitUUID as CVarArg
        )
        fetchRequest.fetchLimit = 1

        return try context.count(for: fetchRequest) > 0
    }
}
