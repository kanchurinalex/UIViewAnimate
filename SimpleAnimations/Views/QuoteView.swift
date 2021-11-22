import UIKit

class QuoteView: UIView {
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var didRate: (() -> Void)?
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        label.backgroundColor = UIColor.systemGray6
        label.textAlignment = .center
        return label
    }()
    
    private let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.alpha = 0
        imageView.image = UIImage(systemName: "hand.thumbsup.fill")
        imageView.tintColor = Constants.Colors.green
        return imageView
    }()
    
    private var animator: UIViewPropertyAnimator?
    private var like = true
    
    // MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if animator == nil {
            label.frame = bounds.insetBy(dx: 20, dy: 10)
            thumbImageView.frame = bounds.insetBy(dx: 20, dy: 10)
        }
    }
    
    private func setup() {
        addSubview(label)
        addSubview(thumbImageView)
        
        label.layer.borderWidth = 1
        label.layer.cornerRadius = Constants.Floats.cornerRadius
        
//        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
//        swipeRightRecognizer.direction = .right
//        label.addGestureRecognizer(swipeRightRecognizer)
//
//        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
//        swipeLeftRecognizer.direction = .left
//        label.addGestureRecognizer(swipeLeftRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.addGestureRecognizer(panRecognizer)
    }
}

extension QuoteView {
    @objc private func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            label.frame.origin.x -= 100
            thumbImageView.frame.origin.x -= 100
            thumbImageView.tintColor = UIColor.systemRed
            thumbImageView.image = UIImage(systemName: "hand.thumbsdown.fill")
            thumbImageView.alpha = 1
        case .right:
            label.frame.origin.x += 100
            thumbImageView.frame.origin.x += 100
            thumbImageView.tintColor = UIColor.systemGreen
            thumbImageView.image = UIImage(systemName: "hand.thumbsup.fill")
            thumbImageView.alpha = 1
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.label.frame = self.bounds
            self.thumbImageView.frame = self.bounds
            self.thumbImageView.image = nil
            self.thumbImageView.alpha = 0
            self.didRate?()
        }
    }
    
    @objc private func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self).x
        
        switch sender.state {
        case .began:
            like = translation > 0
            
            let endX = like ? 3 * bounds.width / 2 + 50 : -bounds.width / 2 - 50
            let angle = like ? CGFloat.pi / 4 : -CGFloat.pi / 4
            let thumbImage = like ? "hand.thumbsup.fill" : "hand.thumbsdown.fill"
            thumbImageView.image = UIImage(systemName: thumbImage)
            thumbImageView.tintColor = like ? Constants.Colors.green : Constants.Colors.red
            
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
                [self.label, self.thumbImageView].forEach {
                    $0.center = CGPoint(x: endX, y: self.bounds.height / 2)
                    $0.transform = CGAffineTransform(rotationAngle: angle)
                }
                self.thumbImageView.alpha = 1
            }
            animator?.addCompletion { [weak self] some in
                guard let self = self else { return }
                
                [self.label, self.thumbImageView].forEach {
                    $0.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
                    $0.transform = .identity
                }
                self.thumbImageView.alpha = 0
                
                self.alpha = 0
                self.didRate?()
                
                UIView.animate(withDuration: 0.2) {
                    self.alpha = 1
                }
            }
            
        case .changed:
            let slide = like ? max(translation, 0) : min(translation, 0)
            animator?.fractionComplete = abs(slide) / bounds.width
            
        case .ended:
            animator?.startAnimation()
            
        default:
            break
        }
    }
}
