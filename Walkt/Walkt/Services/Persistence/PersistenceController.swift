import Foundation
import CoreData

// MARK: - Persistence Controller

/// Manages the Core Data stack (NSPersistentContainer) for the app.
/// Provides the view context for main-thread reads and a factory
/// for background contexts used during HealthKit sync.
final class PersistenceController {

    // MARK: - Shared Instance

    static let shared = PersistenceController()

    // MARK: - Properties

    let container: NSPersistentContainer

    /// Main-thread context for UI reads.
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Initialization

    /// Creates the persistence controller.
    /// - Parameter inMemory: When true, uses an in-memory store (for unit tests).
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Walkt")

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data store failed to load: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Background Context

    /// Creates a new background context for write operations.
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
