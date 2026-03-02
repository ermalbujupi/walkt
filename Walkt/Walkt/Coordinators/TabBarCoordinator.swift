import UIKit

// MARK: - Tab Bar Coordinator

/// Manages the main tab bar interface and its child coordinators.
/// Each tab has its own navigation controller and coordinator.
final class TabBarCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let tabBarController: UITabBarController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        let dashboardNav = UINavigationController()
        let mapNav = UINavigationController()
        let historyNav = UINavigationController()
        let settingsNav = UINavigationController()

        // Dashboard (Today)
        let dashboardCoordinator = DashboardCoordinator(navigationController: dashboardNav)
        dashboardNav.tabBarItem = UITabBarItem(
            title: "Today",
            image: UIImage(systemName: "figure.walk"),
            tag: 0
        )

        // Map (Routes)
        let mapCoordinator = MapCoordinator(navigationController: mapNav)
        mapNav.tabBarItem = UITabBarItem(
            title: "Routes",
            image: UIImage(systemName: "map"),
            tag: 1
        )

        // History
        let historyCoordinator = HistoryCoordinator(navigationController: historyNav)
        historyNav.tabBarItem = UITabBarItem(
            title: "History",
            image: UIImage(systemName: "clock.arrow.circlepath"),
            tag: 2
        )

        // Settings
        let settingsCoordinator = SettingsCoordinator(navigationController: settingsNav)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 3
        )

        // Store child coordinators
        addChild(dashboardCoordinator)
        addChild(mapCoordinator)
        addChild(historyCoordinator)
        addChild(settingsCoordinator)

        // Start each coordinator
        dashboardCoordinator.start()
        mapCoordinator.start()
        historyCoordinator.start()
        settingsCoordinator.start()

        // Configure tab bar
        tabBarController.viewControllers = [dashboardNav, mapNav, historyNav, settingsNav]
        tabBarController.tabBar.tintColor = .systemBlue

        navigationController.setViewControllers([tabBarController], animated: false)
    }
}
