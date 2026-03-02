import UIKit

// MARK: - App Coordinator

/// Root coordinator that manages the app's top-level navigation.
/// Decides whether to show onboarding or the main tab bar interface.
final class AppCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    private let window: UIWindow

    init(window: UIWindow, navigationController: UINavigationController = UINavigationController()) {
        self.window = window
        self.navigationController = navigationController
    }

    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)

        if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            showMainInterface()
        } else {
            // TODO: Show onboarding flow (Commit 3.2)
            // For now, skip straight to main interface
            showMainInterface()
        }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    // MARK: - Navigation

    private func showMainInterface() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        addChild(tabBarCoordinator)
        tabBarCoordinator.start()
    }
}
