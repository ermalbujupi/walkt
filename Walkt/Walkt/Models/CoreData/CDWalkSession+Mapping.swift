import Foundation
import CoreData

// MARK: - CDWalkSession Domain Mapping

extension CDWalkSession {

    /// Converts this managed object to a domain WalkSession value type.
    func toDomain() -> WalkSession {
        WalkSession(
            id: id,
            healthKitUUID: healthKitUUID,
            startDate: startDate,
            endDate: endDate,
            duration: duration,
            totalDistanceMeters: totalDistanceMeters,
            totalEnergyKcal: totalEnergyKcal,
            averageSpeedMPS: averageSpeedMPS,
            maxSpeedMPS: maxSpeedMPS,
            totalSteps: Int(totalSteps),
            elevationGainMeters: elevationGainMeters,
            elevationLossMeters: elevationLossMeters,
            hasRouteData: hasRouteData,
            isIndoor: isIndoor,
            sourceName: sourceName,
            walkType: WalkType(rawValue: walkTypeRaw) ?? .unknown
        )
    }

    /// Populates this managed object's properties from a domain WalkSession.
    func update(from session: WalkSession) {
        id = session.id
        healthKitUUID = session.healthKitUUID
        startDate = session.startDate
        endDate = session.endDate
        duration = session.duration
        totalDistanceMeters = session.totalDistanceMeters
        totalEnergyKcal = session.totalEnergyKcal
        averageSpeedMPS = session.averageSpeedMPS
        maxSpeedMPS = session.maxSpeedMPS
        totalSteps = Int32(session.totalSteps)
        elevationGainMeters = session.elevationGainMeters
        elevationLossMeters = session.elevationLossMeters
        hasRouteData = session.hasRouteData
        isIndoor = session.isIndoor
        sourceName = session.sourceName
        walkTypeRaw = session.walkType.rawValue
    }
}
