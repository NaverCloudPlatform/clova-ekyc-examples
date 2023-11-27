/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class ScenarioTableViewCell: UITableViewCell {

    private let backView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaBlack.uiColor
        $0.makeRoundBorder(radius: 2)
        return $0
    }(UIView())

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: 500)
        $0.minimumScaleFactor = 0.5
        return $0
    }(UILabel())

    private let nextImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.icon_next.uiImage
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

extension ScenarioTableViewCell {

    func set(title: String) {
        titleLabel.text = title
    }
}

extension ScenarioTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            backView.leftAnchor.constraint(equalTo: leftAnchor),
            backView.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        backView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 27),
            titleLabel.heightAnchor.constraint(equalToConstant: 19),
        ])

        backView.addSubview(nextImageView)
        NSLayoutConstraint.activate([
            nextImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            nextImageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 27),
            nextImageView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -27),
            nextImageView.widthAnchor.constraint(equalToConstant: 6),
            nextImageView.heightAnchor.constraint(equalToConstant: 12),
        ])

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 69)
        ])
    }
}
