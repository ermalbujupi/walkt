import UIKit

// MARK: - Coordinator Protocol

/// Base protocol for the coordinator pattern.
/// Coordinators own navigation controllers and manage view controller presentation,
/// decoupling navigation logic from individual view controllers.
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}

extension Coordinator {

    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
