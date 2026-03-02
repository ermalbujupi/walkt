import UIKit

// MARK: - Settings Coordinator

final class SettingsCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = SettingsViewController()
        viewController.title = "Settings"
        navigationController.setViewControllers([viewController], animated: false)
    }
}
