import UIKit

final class TitledTextField: UITextField {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(titleLabel)
    }
}
