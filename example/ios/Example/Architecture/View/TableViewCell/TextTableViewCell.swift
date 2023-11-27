/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class TextTableViewCell: UITableViewCell {

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

extension TextTableViewCell {

    func set(value: String?) {
        valueLabel.text = value
    }
}

extension TextTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        contentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            valueLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
        ])
    }
}
