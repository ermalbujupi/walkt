import UIKit

// MARK: - Map View Controller

/// Map screen for displaying walking routes.
/// Will be expanded with MKMapView, route polylines,
/// speed gradients, and altitude profiles in Phase 6.
final class MapViewController: UIViewController {

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Routes"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your walking routes will appear here"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupPlaceholder()
    }

    private func setupPlaceholder() {
        view.addSubview(placeholderLabel)
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
