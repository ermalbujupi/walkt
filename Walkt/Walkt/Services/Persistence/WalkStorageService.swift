import Foundation
import Combine

// MARK: - Walk Storage Service Protocol

/// Defines CRUD operations for persisting walk sessions and route points.
/// Protocol-based for testability.
protocol WalkStorageService: AnyObject {

    /// Persists a walk session with its associated route points.
    /// If a session with the same id already exists, it is updated.
    func save(walkSession session: WalkSession, routePoints: [RoutePoint]) throws

    /// Fetches all walk sessions, ordered by start date descending.
    func fetchAll() throws -> [WalkSession]

    /// Fetches a single walk session by its unique identifier.
    func fetch(byId id: UUID) throws -> WalkSession?

    /// Fetches walk sessions within a date range.
    func fetchSessions(from startDate: Date, to endDate: Date) throws -> [WalkSession]

    /// Fetches all route points for a given walk session, ordered by sortOrder.
    func fetchRoutePoints(for walkSessionId: UUID) throws -> [RoutePoint]

    /// Deletes a walk session and its associated route points (via cascade).
    func delete(walkSessionId: UUID) throws

    /// Checks whether a walk session with the given HealthKit UUID already exists.
    /// Used during sync to prevent duplicate imports.
    func exists(healthKitUUID: UUID) throws -> Bool

    /// Publisher that emits whenever the walk session store changes.
    var sessionsDidChange: PassthroughSubject<Void, Never> { get }
}
