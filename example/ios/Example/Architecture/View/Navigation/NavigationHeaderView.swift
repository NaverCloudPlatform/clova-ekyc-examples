/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class NavigationHeaderView: UIView {

    var tapBack: (() -> Void)?
    var tapRightButton: (() -> Void)?

    let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(UIView())

    let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 17, weight: 700)
        $0.textAlignment = .center
        return $0
    }(UILabel())

    lazy var backButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(AssetImage.icon_back.uiImage, for: .normal)
        $0.addTarget(self, action: #selector(tapBackButton))
        return $0
    }(UIButton())

    private lazy var rightButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tapRightNavButton))
        return $0
    }(UIButton())

    init(title: String? = nil) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationHeaderView {

    func set(rightButtonImage: UIImage?) {
        rightButton.isHidden = false
        rightButton.setImage(rightButtonImage, for: .normal)
    }

    func set(tintColor: UIColor) {
        let backImage = AssetImage.icon_back.uiImage?.withTintColor(tintColor, renderingMode: .alwaysOriginal)
        titleLabel.textColor = tintColor
        backButton.setImage(backImage, for: .normal)
    }
}

extension NavigationHeaderView {

    private func configureLayout() {
        backgroundColor = .clear
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 56)
        ])

        contentView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 17),
            backButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 28),
            backButton.widthAnchor.constraint(equalToConstant: 28)
        ])

        contentView.addSubview(rightButton)
        NSLayoutConstraint.activate([
            rightButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -17),
            rightButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 28),
            rightButton.widthAnchor.constraint(equalToConstant: 28)
        ])

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: -10)
        ])

        rightButton.isHidden = true
    }

    @objc
    private func tapBackButton() {
        tapBack?()
    }

    @objc
    private func tapRightNavButton() {
        tapRightButton?()
    }
}
