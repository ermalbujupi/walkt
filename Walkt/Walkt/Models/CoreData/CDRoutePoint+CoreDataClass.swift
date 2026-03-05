import Foundation
import CoreData

// MARK: - CDRoutePoint

/// Core Data managed object for persisted GPS route points.
/// Maps to the RoutePoint domain model via toDomain() / update(from:).
@objc(CDRoutePoint)
public final class CDRoutePoint: NSManagedObject {

    // MARK: - Properties

    @NSManaged var id: UUID
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var altitude: Double
    @NSManaged var speed: Double
    @NSManaged var timestamp: Date
    @NSManaged var horizontalAccuracy: Double
    @NSManaged var sortOrder: Int32
    @NSManaged var walkSession: CDWalkSession?

    // MARK: - Fetch Request

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDRoutePoint> {
        return NSFetchRequest<CDRoutePoint>(entityName: "CDRoutePoint")
    }
}
