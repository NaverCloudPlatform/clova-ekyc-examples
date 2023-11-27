/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class ErrorTableViewCell: UITableViewCell {

    static let height = CGFloat(25)

    private let errorLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 400)
        $0.numberOfLines = 1
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.textAlignment = .left
        $0.textColor = AssetColor.clovaRed.uiColor
        $0.backgroundColor = .clear
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

extension ErrorTableViewCell {

    func set(error: String?) {
        errorLabel.text = error
    }
}

extension ErrorTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        contentView.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            errorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 35),
            errorLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
