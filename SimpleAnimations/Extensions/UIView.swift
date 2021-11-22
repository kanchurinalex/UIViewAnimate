import UIKit

extension UIView.AnimationOptions {
    init(_ animationCurve: UIView.AnimationCurve) {
        switch animationCurve {
        case .easeIn:
            self = .curveEaseIn
        case .easeInOut:
            self = .curveEaseInOut
        case .easeOut:
            self = .curveEaseOut
        case .linear:
            self = .curveLinear
        default:
            self = .curveLinear
        }
    }
}
