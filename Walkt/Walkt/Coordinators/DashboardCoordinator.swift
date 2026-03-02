import UIKit

// MARK: - Dashboard Coordinator

final class DashboardCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = DashboardViewController()
        viewController.title = "Today"
        navigationController.setViewControllers([viewController], animated: false)
    }
}
