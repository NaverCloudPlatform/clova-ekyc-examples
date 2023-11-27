/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class TextInputTableViewCell: UITableViewCell {

    var valueUpdated: ((String?) -> Void)?
    var showAlert: ((UIAlertController) -> Void)?

    static let height = CGFloat(40)

    private var title: String?

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
        $0.font = .systemFont(ofSize: 16, weight: 500)
        $0.textAlignment = .left
        $0.textColor = AssetColor.clovaBlack.uiColor?.withAlphaComponent(0.6)
        $0.isUserInteractionEnabled = false
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

extension TextInputTableViewCell {

    func set(title: String) {
        self.title = title
    }

    func set(value: String?) {
        inputLabel.text = value
    }
}

extension TextInputTableViewCell {

    private func configureLayout() {
        backgroundColor = .clear
        contentView.addSubview(inputButton)
        NSLayoutConstraint.activate([
            inputButton.topAnchor.constraint(equalTo: topAnchor),
            inputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            inputButton.rightAnchor.constraint(equalTo: rightAnchor),
            inputButton.leftAnchor.constraint(equalTo: leftAnchor),
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

    @objc
    private func tapInputButton() {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = inputLabel.text
        alert.textFields?.first?.clearButtonMode = .always
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
            let text = alert.textFields?.first?.text
            self?.valueUpdated?(text)
            self?.inputLabel.text = text
        }))

        showAlert?(alert)
    }
}
