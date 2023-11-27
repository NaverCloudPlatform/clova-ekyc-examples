/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class CheckLabel: UIView {

    private let iconImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.icon_success.uiImage
        return $0
    }(UIImageView())

    private let textLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: 500)
        return $0
    }(UILabel())

    var text: String? {
        get {
            return textLabel.text
        }

        set {
            textLabel.text = newValue
        }
    }

    var isChecked: Bool {
        get {
            return !iconImageView.isHidden
        }

        set {
            iconImageView.isHidden = !newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckLabel {

    private func configureLayout() {
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 20)
        ])

        addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 12)
        ])

        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
