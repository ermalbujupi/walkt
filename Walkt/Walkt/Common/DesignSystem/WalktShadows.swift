import UIKit

// MARK: - Design System Shadows

enum WalktShadows {

    /// Applies a subtle card shadow to the given layer.
    static func applyCardShadow(to layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }

    /// Applies a stronger elevated shadow for floating elements.
    static func applyElevatedShadow(to layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 12
        layer.masksToBounds = false
    }
}
