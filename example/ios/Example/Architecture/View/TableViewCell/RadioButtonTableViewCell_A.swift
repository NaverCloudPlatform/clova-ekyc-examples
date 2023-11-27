/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class RadioButtonTableViewCell_A: UITableViewCell {

    static let height = CGFloat(26)

    private let radioButton: RadioButtonView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(RadioButtonView())

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 17, weight: 500)
        $0.textColor = .white
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RadioButtonTableViewCell_A {

    func set(title: String) {
        titleLabel.text = title
    }

    func set(isSelected: Bool) {
        radioButton.isSelected = isSelected
    }

    func set(isEnabled: Bool) {
        if isEnabled {
            radioButton.alpha = 1.0
            titleLabel.textColor = .white
        } else {
            radioButton.isSelected = false
            radioButton.alpha = 0.5
            titleLabel.textColor = .white.withAlphaComponent(0.5)
        }
    }
}

extension RadioButtonTableViewCell_A {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: leftAnchor),
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
