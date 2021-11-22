import UIKit

class ViewController: UIViewController {
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var quoteLabel: UILabel!
    @IBOutlet private var likeImageView: UIImageView!
    @IBOutlet private var likesLabel: UILabel!
    
    @IBOutlet private var quoteView: QuoteView!
    
    @IBOutlet private var nicknameTextField: TitledTextField!
    @IBOutlet private var quoteTextField: TitledTextField!
    @IBOutlet private var postButton: UIButton!
    
    @IBOutlet private var topContentConstraint: NSLayoutConstraint!
    @IBOutlet private var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var avatarTopConstraint: NSLayoutConstraint!
    @IBOutlet private var avatarHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var quoteTopConstraint: NSLayoutConstraint!
    @IBOutlet private var quoteBottomConstraint: NSLayoutConstraint!

    private var numberOfLikes = 0 {
        didSet {
            likesLabel.text = String(numberOfLikes)
        }
    }
    
    private var likesUpdateItem: DispatchWorkItem?
    
    private var keyboardIsShown = false
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardChange(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardChange(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        quoteView.text = generateQuote()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        avatarImageView.layer.cornerRadius = Constants.Floats.cornerRadius
        quoteLabel.text = nil
        
        quoteView.didRate = { [weak self] in
            guard let self = self else { return }
            self.quoteView.text = self.generateQuote()
        }
        
        [quoteTextField, nicknameTextField].compactMap { $0 }.forEach {
            $0.layer.borderWidth = 1.5
            $0.layer.cornerRadius = Constants.Floats.cornerRadius
            $0.delegate = self
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
        }
        
        quoteTextField.layer.borderColor = Constants.Colors.purple.cgColor
        quoteTextField.titleLabel.textColor = Constants.Colors.purple
        quoteTextField.titleLabel.text = "Your quote"

        nicknameTextField.layer.borderColor = Constants.Colors.green.cgColor
        nicknameTextField.titleLabel.textColor = Constants.Colors.green
        nicknameTextField.titleLabel.text = "Your nickname"
        
        postButton.layer.cornerRadius = Constants.Floats.cornerRadius
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
}

// MARK: - Animations

extension ViewController {
    private func animateContent(duration: TimeInterval, animationCurve: UIView.AnimationCurve, showKeyboard: Bool) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(animationCurve)
        ) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func focus(textField: TitledTextField, isTyping: Bool, animated: Bool) {
        UIView.transition(
            with: textField,
            duration: animated ? 0.5 : 0,
            options: [.transitionCrossDissolve, .allowAnimatedContent]
        ) {
            textField.contentVerticalAlignment = isTyping ? .bottom : .center
            textField.titleLabel.isHidden = !isTyping
            textField.layer.borderWidth = isTyping ? 3 : 1.5
        }
    }
    
    private func animateLikes() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: [.calculationModeCubic]
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.125) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 8)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.625, relativeDuration: 0.125) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 8)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.750, relativeDuration: 0.125) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 16)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.125) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 16)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.875, relativeDuration: 0.125) {
                self.likeImageView.transform = CGAffineTransform(rotationAngle: 0)
            }
        }
    }
    
    private func animateTextFieldEmpty(textField: TitledTextField, delay: TimeInterval = 0) {
        textField.center.x += 20
        UIView.animate(
            withDuration: 1,
            delay: delay,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0,
            options: []) {
            textField.center.x -= 20
        }
    }
}

// MARK: - UI Actions

extension ViewController: UITextFieldDelegate {
    @objc private func keyboardChange(notification: Notification) {
        guard let info = notification.userInfo,
              let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let animationCurveValue = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
              let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue),
              let keyboardFrameEnd = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        let showKeyboard = keyboardFrameEnd.minY < view.bounds.height
        if showKeyboard && headerHeightConstraint.constant == 150 {
            let postFrame = contentView.convert(postButton.frame, to: view)
            let diff = abs(postFrame.maxY - keyboardFrameEnd.minY)
            
            headerHeightConstraint.constant = 20
            avatarHeightConstraint.constant = 150 + 130 - 60 - diff
            avatarTopConstraint.constant = -15
            quoteBottomConstraint.isActive = false
            likeImageView.isHidden = true
            likesLabel.isHidden = true
            
        } else if !showKeyboard {
            headerHeightConstraint.constant = 150
            avatarTopConstraint.constant = -75
            avatarHeightConstraint.constant = 150
            quoteBottomConstraint.isActive = true
            likeImageView.isHidden = false
            likesLabel.isHidden = false
        }
        
        keyboardIsShown = showKeyboard
        
        animateContent(duration: duration, animationCurve: animationCurve, showKeyboard: showKeyboard)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let field = textField as? TitledTextField else { return }
        focus(textField: field, isTyping: field.isFirstResponder, animated: keyboardIsShown)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = textField as? TitledTextField else { return }
        focus(textField: field, isTyping: field.isFirstResponder, animated: keyboardIsShown)
    }
    
    @IBAction private func post(_ sender: UIButton) {
        updateMyQuote()
    }
    
    @objc private func tap() {
        view.endEditing(true)
    }
}

// MARK: - Helpers

extension ViewController {
    private func updateLikes() {
        guard likesUpdateItem == nil else { return }
        
        let likesUpdateItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.numberOfLikes = self.numberOfLikes + 1
            self.animateLikes()
            self.likesUpdateItem = nil
            
            self.updateLikes()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: likesUpdateItem)
        
        self.likesUpdateItem = likesUpdateItem
    }
    
    private func resetLikes() {
        quoteLabel.text = nil
        
        likesUpdateItem?.cancel()
        likesUpdateItem = nil
        
        numberOfLikes = 0
    }
    
    private func generateQuote() -> String {
        quotes.randomElement() ?? ""
    }
    
    private func updateMyQuote() {
        let quoteText = quoteTextField.text ?? ""
        let nicknameText = nicknameTextField.text ?? ""
        
        let quoteIsFilled = quoteText.count > 0
        let nicknameIsFilled = nicknameText.count > 0
        
        guard quoteIsFilled && nicknameIsFilled else {
            if !quoteIsFilled {
                animateTextFieldEmpty(textField: quoteTextField)
            }
            if !nicknameIsFilled {
                animateTextFieldEmpty(textField: nicknameTextField, delay: quoteIsFilled ? 0 : 0.1)
            }
            return
        }
        
        quoteTextField.text = nil
        nicknameTextField.text = nil
        
        resetLikes()
        
        quoteLabel.text = String("\"\(quoteText)\"\n\(nicknameText)")
        
        updateLikes()
    }
}

// MARK: - Quotes

extension UIViewController {
    var quotes: [String] {
        [
            "Не волнуйтесь, если что-то не работает. Если бы всё работало, вас бы уволили.",
            "В теории, теория и практика неразделимы. На практике это не так.",
            "Я изобрел понятие «объектно-ориентированный», и могу заявить, что не имел в виду C++.",
            "Иногда лучше остаться спать дома в понедельник, чем провести всю неделю в отладке написанного в понедельник кода.",
            "Измерять продуктивность программиста подсчетом строк кода — это так же, как оценивать постройку самолета по его весу.",
            "Программисты — не математики, как бы нам этого ни хотелось.",
            "Работает? Не трогай.",
            "Java — это C++, из которого убрали все пистолеты, ножи и дубинки.",
            "Насколько проще было бы писать программы, если бы не заказчики.",
            "Молодые специалисты не умеют работать, а опытные специалисты умеют не работать.",
            "Чтобы понять рекурсию, нужно сперва понять рекурсию.",
            "Удаленный код — отлаженный код.",
            "Самые дешевые, быстрые и надежные компоненты те, которых тут нет."
        ]
    }
}
