/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class TextInfoTableViewCell: UITableViewCell {

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: 500)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        return $0
    }(UILabel())

    private let valueLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: 500)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.textColor = .white
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

extension TextInfoTableViewCell {

    func set(title: String?, color: UIColor?) {
        titleLabel.text = title
        titleLabel.textColor = color
    }

    func set(value: String?, color: UIColor?) {
        valueLabel.text = value
        valueLabel.textColor = color
    }
}

extension TextInfoTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        contentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -15),
        ])
    }
}
