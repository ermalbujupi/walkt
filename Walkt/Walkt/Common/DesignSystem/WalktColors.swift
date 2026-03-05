import UIKit

// MARK: - Design System Colors

enum WalktColors {

    // MARK: - Brand

    static let primary: UIColor = .systemBlue
    static let secondary: UIColor = .systemTeal

    // MARK: - Metric Card Accents

    static let distance: UIColor = .systemBlue
    static let steps: UIColor = .systemGreen
    static let calories: UIColor = .systemOrange
    static let duration: UIColor = .systemPurple
    static let elevation: UIColor = .systemTeal

    // MARK: - Speed Gradient

    static let speedSlow: UIColor = .systemBlue
    static let speedModerate: UIColor = .systemGreen
    static let speedFast: UIColor = .systemOrange

    // MARK: - Surfaces

    static let background: UIColor = .systemBackground
    static let secondaryBackground: UIColor = .secondarySystemBackground
    static let groupedBackground: UIColor = .systemGroupedBackground
    static let cardBackground: UIColor = .secondarySystemGroupedBackground

    // MARK: - Text

    static let label: UIColor = .label
    static let secondaryLabel: UIColor = .secondaryLabel
    static let tertiaryLabel: UIColor = .tertiaryLabel

    // MARK: - Utility

    static let separator: UIColor = .separator
    static let success: UIColor = .systemGreen
    static let warning: UIColor = .systemYellow
    static let error: UIColor = .systemRed

    // MARK: - Helpers

    /// Returns the accent color at 10% opacity, used for metric card backgrounds.
    static func cardTint(for color: UIColor) -> UIColor {
        color.withAlphaComponent(0.1)
    }
}
