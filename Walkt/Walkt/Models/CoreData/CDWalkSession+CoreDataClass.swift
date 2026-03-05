import Foundation
import CoreData

// MARK: - CDWalkSession

/// Core Data managed object for persisted walking sessions.
/// Maps to the WalkSession domain model via toDomain() / update(from:).
@objc(CDWalkSession)
public final class CDWalkSession: NSManagedObject {

    // MARK: - Properties

    @NSManaged var id: UUID
    @NSManaged var healthKitUUID: UUID
    @NSManaged var startDate: Date
    @NSManaged var endDate: Date
    @NSManaged var duration: Double
    @NSManaged var totalDistanceMeters: Double
    @NSManaged var totalEnergyKcal: Double
    @NSManaged var averageSpeedMPS: Double
    @NSManaged var maxSpeedMPS: Double
    @NSManaged var totalSteps: Int32
    @NSManaged var elevationGainMeters: Double
    @NSManaged var elevationLossMeters: Double
    @NSManaged var hasRouteData: Bool
    @NSManaged var isIndoor: Bool
    @NSManaged var sourceName: String
    @NSManaged var walkTypeRaw: Int16
    @NSManaged var routePoints: NSOrderedSet?

    // MARK: - Fetch Request

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDWalkSession> {
        return NSFetchRequest<CDWalkSession>(entityName: "CDWalkSession")
    }

    // MARK: - Ordered Set Accessors (routePoints)

    @objc(addRoutePointsObject:)
    @NSManaged func addToRoutePoints(_ value: CDRoutePoint)

    @objc(removeRoutePointsObject:)
    @NSManaged func removeFromRoutePoints(_ value: CDRoutePoint)

    @objc(addRoutePoints:)
    @NSManaged func addToRoutePoints(_ values: NSOrderedSet)

    @objc(removeRoutePoints:)
    @NSManaged func removeFromRoutePoints(_ values: NSOrderedSet)
}
