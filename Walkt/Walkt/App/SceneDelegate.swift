import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let rootVC = UIViewController()
        rootVC.view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = "Walkt"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        rootVC.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: rootVC.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: rootVC.view.centerYAnchor)
        ])

        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }
}
