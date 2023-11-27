/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class InputTextField: UIView {

    var buttonClicked: (() -> Void)?

    private var placeholder: String?

    private lazy var inputButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(nil, for: .normal)
        $0.backgroundColor = AssetColor.gray10.uiColor
        $0.addTarget(self, action: #selector(tapInputButton))
        $0.makeRoundBorder(radius: 2)
        $0.layer.borderWidth = 1
        return $0
    }(UIButton())

    private let inputLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 500)
        $0.textAlignment = .left
        $0.isUserInteractionEnabled = false
        return $0
    }(UILabel())

    init(placeholder: String?) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        configureLayout()
        set(text: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputTextField {

    func set(text: String?) {
        if let inputText = text, !inputText.isEmpty {
            inputLabel.text = text
            inputLabel.textColor = .white
            inputButton.layer.borderColor = AssetColor.clovaGreen.uiColor?.cgColor
        } else {
            inputLabel.text = placeholder
            inputLabel.textColor = .white.withAlphaComponent(0.6)
            inputButton.layer.borderColor = AssetColor.gray11.uiColor?.cgColor
        }
    }
}

extension InputTextField {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(inputButton)
        NSLayoutConstraint.activate([
            inputButton.topAnchor.constraint(equalTo: topAnchor),
            inputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            inputButton.rightAnchor.constraint(equalTo: rightAnchor),
            inputButton.leftAnchor.constraint(equalTo: leftAnchor),
        ])

        addSubview(inputLabel)
        NSLayoutConstraint.activate([
            inputLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputLabel.leftAnchor.constraint(
                equalTo: inputButton.leftAnchor, constant: 15),
            inputLabel.rightAnchor.constraint(
                equalTo: inputButton.rightAnchor, constant: -15)
        ])

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 43)
        ])
    }

    @objc
    private func tapInputButton() {
        buttonClicked?()
    }
}
