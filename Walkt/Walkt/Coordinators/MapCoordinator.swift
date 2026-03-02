import UIKit

// MARK: - Map Coordinator

final class MapCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MapViewController()
        viewController.title = "Routes"
        navigationController.setViewControllers([viewController], animated: false)
    }
}
