/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class AlertViewController: UIViewController {

    var buttonTapped: (() -> Void)?
    var dismissed: (() -> Void)?

    private let roundView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.gray3.uiColor
        $0.makeRoundBorder(radius: 18)
        return $0
    }(UIView())

    private let handleBarView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.gray8.uiColor?.withAlphaComponent(0.2)
        $0.makeRoundBorder(radius: 2)
        return $0
    }(UIView())

    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.gray3.uiColor
        return $0
    }(UIView())

    private lazy var gestureView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.addGestureRecognizer(tapGestureRecognizer)
        return $0
    }(UIView())

    private let iconImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private let guideLabel1: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private let guideLabel2: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        $0.alpha = 0.6
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaGreen.uiColor
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(tapButton))
        return $0
    }(UIButton())

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        $0.cancelsTouchesInView = true
        $0.numberOfTapsRequired = 1
        $0.addTarget(self, action: #selector(tappedBackgroundView))
        return $0
    }(UITapGestureRecognizer())

    init(icon: UIImage?, guideText1: String, guideText2: String, buttonText: String) {
        super.init(nibName: nil, bundle: nil)
        iconImageView.image = icon
        guideLabel1.text = guideText1
        guideLabel2.text = guideText2
        button.setTitle(buttonText, for: .normal)
        modalPresentationStyle = .pageSheet
        modalTransitionStyle = .coverVertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlertViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissed?()
    }
}

extension AlertViewController {

    private func configureLayout() {
        view.backgroundColor = .clear
        view.addSubview(roundView)
        NSLayoutConstraint.activate([
            roundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            roundView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: roundView.topAnchor, constant: 60),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(gestureView)
        NSLayoutConstraint.activate([
            gestureView.topAnchor.constraint(equalTo: view.topAnchor),
            gestureView.bottomAnchor.constraint(equalTo: roundView.topAnchor),
            gestureView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gestureView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        roundView.addSubview(handleBarView)
        NSLayoutConstraint.activate([
            handleBarView.topAnchor.constraint(equalTo: roundView.topAnchor, constant: 12),
            handleBarView.centerXAnchor.constraint(equalTo: roundView.centerXAnchor),
            handleBarView.heightAnchor.constraint(equalToConstant: 4),
            handleBarView.widthAnchor.constraint(equalToConstant: 47),
        ])

        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
        ])

        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -34),
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34),
            button.heightAnchor.constraint(equalToConstant: 54),
        ])

        contentView.addSubview(guideLabel2)
        NSLayoutConstraint.activate([
            guideLabel2.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -55),
            guideLabel2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            guideLabel2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34)
        ])

        contentView.addSubview(guideLabel1)
        NSLayoutConstraint.activate([
            guideLabel1.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            guideLabel1.bottomAnchor.constraint(equalTo: guideLabel2.topAnchor, constant: -7),
            guideLabel1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 34),
            guideLabel1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -34)
        ])
    }

    @objc
    private func tappedBackgroundView() {
        dismiss(animated: true)
    }

    @objc
    private func tapButton() {
        buttonTapped?()
        dismiss(animated: true)
    }
}
