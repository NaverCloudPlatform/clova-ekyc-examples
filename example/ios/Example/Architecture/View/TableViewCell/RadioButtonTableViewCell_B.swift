/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class RadioButtonTableViewCell_B: UITableViewCell {

    static let height = CGFloat(22)

    private let radioButton: RadioButtonView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderColor = AssetColor.gray7.uiColor
        return $0
    }(RadioButtonView())

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 400)
        $0.textColor = AssetColor.clovaBlack.uiColor
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

extension RadioButtonTableViewCell_B {

    func set(title: String) {
        titleLabel.text = title
    }

    func set(isSelected: Bool) {
        radioButton.isSelected = isSelected
    }
}

extension RadioButtonTableViewCell_B {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: leftAnchor),
            radioButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
