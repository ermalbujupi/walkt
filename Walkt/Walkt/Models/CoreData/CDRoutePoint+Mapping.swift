import Foundation
import CoreData

// MARK: - CDRoutePoint Domain Mapping

extension CDRoutePoint {

    /// Converts this managed object to a domain RoutePoint value type.
    func toDomain() -> RoutePoint {
        RoutePoint(
            id: id,
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            speed: speed,
            timestamp: timestamp,
            horizontalAccuracy: horizontalAccuracy,
            sortOrder: Int(sortOrder)
        )
    }

    /// Populates this managed object's properties from a domain RoutePoint.
    func update(from point: RoutePoint) {
        id = point.id
        latitude = point.latitude
        longitude = point.longitude
        altitude = point.altitude
        speed = point.speed
        timestamp = point.timestamp
        horizontalAccuracy = point.horizontalAccuracy
        sortOrder = Int32(point.sortOrder)
    }
}
