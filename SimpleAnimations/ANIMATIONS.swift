// CONSTRAINTS
// view.layoutIfNeeded()
// likeImageView.alpha = showKeyboard ? 0 : 1




// SPRING
//textField.center.x += 20
//UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: [], animations: {
//    textField.center.x -= 20
//})




// KEYFRAME
//UIView.animateKeyframes(withDuration: 1, delay: 0, options: []) {
//    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
//    }
//    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
//    }
//    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.125) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 8)
//    }
//    UIView.addKeyframe(withRelativeStartTime: 0.625, relativeDuration: 0.125) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 8)
//    }
//    UIView.addKeyframe(withRelativeStartTime: 0.750, relativeDuration: 0.125) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 16)
//    }
//    UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.125) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 16)
//    }
//    UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.125) {
//        self.likeImageView.transform = CGAffineTransform(rotationAngle: 0)
//    }
//}




// TRANSITIONS
//UIView.transition(with: textField, duration: animated ? 0.7 : 0, options: [.transitionCrossDissolve, .allowAnimatedContent]) {
//    textField.contentVerticalAlignment = isTyping ? .bottom : .center
//    textField.titleLabel.isHidden = !isTyping
//    textField.layer.borderWidth = isTyping ? 3 : 1.5
//}




// PROPERTYANIMATOR
//@objc private func pan(_ sender: UIPanGestureRecognizer) {
//    let translation = sender.translation(in: self).x
//
//    switch sender.state {
//    case .began:
//        like = translation > 0
//
//        let endX = like ? 3 * bounds.width / 2 + 50 : -bounds.width / 2 - 50
//        let angle = like ? CGFloat.pi / 4 : -CGFloat.pi / 4
//        let thumbImage = like ? "hand.thumbsup.fill" : "hand.thumbsdown.fill"
//        thumbImageView.image = UIImage(systemName: thumbImage)
//        thumbImageView.tintColor = like ? Constants.Colors.green : Constants.Colors.red
//
//        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
//            [self.label, self.thumbImageView].forEach {
//                $0.center = CGPoint(x: endX, y: self.bounds.height / 2)
//                $0.transform = CGAffineTransform(rotationAngle: angle)
//            }
//            self.thumbImageView.alpha = 1
//        }
//        animator?.addCompletion { [weak self] some in
//            guard let self = self else { return }
//
//            [self.label, self.thumbImageView].forEach {
//                $0.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
//                $0.transform = .identity
//            }
//            self.thumbImageView.alpha = 0
//
//            self.alpha = 0
//            self.didRate?()
//
//            UIView.animate(withDuration: 0.2) {
//                self.alpha = 1
//            }
//        }
//
//    case .changed:
//        let slide = like ? max(translation, 0) : min(translation, 0)
//        animator?.fractionComplete = abs(slide) / bounds.width
//
//    case .ended:
//        animator?.startAnimation()
//
//    default:
//        break
//    }
//}
