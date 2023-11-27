/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class NumberInputTableViewCell: UITableViewCell {

    var valueUpdated: ((Double) -> Void)?
    var showAlert: ((UIAlertController) -> Void)?
    
    static let height = CGFloat(75)

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 19, weight: 600)
        $0.textAlignment = .left
        $0.textColor = AssetColor.clovaBlack.uiColor
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 400)
        $0.textAlignment = .left
        $0.textColor = AssetColor.gray6.uiColor
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private lazy var inputButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(nil, for: .normal)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(tapInputButton))
        $0.makeRoundBorder(radius: 2)
        $0.layer.borderColor = AssetColor.gray1.uiColor?.cgColor
        $0.layer.borderWidth = 1
        return $0
    }(UIButton())

    private let inputLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 19, weight: 500)
        $0.textAlignment = .right
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

extension NumberInputTableViewCell {

    func set(title: String?, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }

    func set(value: Double) {
        inputLabel.text = value.description
    }
}

extension NumberInputTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 23),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])

        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 38),
            descriptionLabel.widthAnchor.constraint(equalTo: titleLabel.widthAnchor)
        ])

        contentView.addSubview(inputButton)
        NSLayoutConstraint.activate([
            inputButton.topAnchor.constraint(equalTo: topAnchor),
            inputButton.rightAnchor.constraint(equalTo: rightAnchor),
            inputButton.leftAnchor.constraint(
                equalTo: titleLabel.rightAnchor, constant: 40),
            inputButton.heightAnchor.constraint(equalToConstant: 43)
        ])

        contentView.addSubview(inputLabel)
        NSLayoutConstraint.activate([
            inputLabel.topAnchor.constraint(
                equalTo: inputButton.topAnchor, constant: 5),
            inputLabel.bottomAnchor.constraint(
                equalTo: inputButton.bottomAnchor, constant: -5),
            inputLabel.leftAnchor.constraint(
                equalTo: inputButton.leftAnchor, constant: 11),
            inputLabel.rightAnchor.constraint(
                equalTo: inputButton.rightAnchor, constant: -11)
        ])
    }

    private func showInvalidInputAlert() {
        let text = "Please input float value."
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        showAlert?(alert)
    }

    @objc
    private func tapInputButton() {
        let alert = UIAlertController(title: titleLabel.text, message: descriptionLabel.text, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = inputLabel.text
        alert.textFields?.first?.clearButtonMode = .always
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
            let text = alert.textFields?.first?.text
            if let value = Double(text ?? "") {
                self?.inputLabel.text = value.description
                self?.valueUpdated?(value)
            } else {
                self?.showInvalidInputAlert()
            }
        }))

        showAlert?(alert)
    }
}
