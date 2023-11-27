/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class TextInfoEditTableViewCell: UITableViewCell {

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

    private let editImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.icon_edit.uiImage?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return $0
    }(UIImageView())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextInfoEditTableViewCell {

    func set(title: String?, color: UIColor?) {
        titleLabel.text = title
        titleLabel.textColor = color
    }

    func set(value: String?, color: UIColor?) {
        valueLabel.text = value
        valueLabel.textColor = color
    }
}

extension TextInfoEditTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
        ])

        contentView.addSubview(editImageView)
        NSLayoutConstraint.activate([
            editImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            editImageView.widthAnchor.constraint(equalToConstant: 16),
            editImageView.heightAnchor.constraint(equalToConstant: 16)
        ])

        contentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            valueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 15),
            valueLabel.rightAnchor.constraint(equalTo: editImageView.leftAnchor, constant: -15),
        ])
    }
}
