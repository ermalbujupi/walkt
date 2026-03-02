import UIKit

// MARK: - History Coordinator

final class HistoryCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = HistoryListViewController()
        viewController.title = "History"
        navigationController.setViewControllers([viewController], animated: false)
    }
}
