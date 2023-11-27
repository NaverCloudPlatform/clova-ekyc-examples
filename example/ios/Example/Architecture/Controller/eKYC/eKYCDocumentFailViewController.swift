/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

final class eKYCDocumentFailViewController: UIViewController {

    private let headerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 17, weight: 700)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "Analysis"
        return $0
    }(UILabel())

    private let cardImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())

    private lazy var retryButton: RetryButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(retry))
        return $0
    }(RetryButton())

    private lazy var homeButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaGreen.uiColor
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.setTitle("Move to Main Menu", for: .normal)
        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(goHome))
        return $0
    }(UIButton())

    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = AssetColor.clovaRed.uiColor
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
        $0.font = .systemFont(ofSize: 16, weight: 500)
        return $0
    }(UILabel())

    init(cardImage: UIImage?, message: String) {
        super.init(nibName: nil, bundle: nil)
        cardImageView.image = cardImage
        descriptionLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension eKYCDocumentFailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

extension eKYCDocumentFailViewController {

    private func configureLayout() {
        view.backgroundColor = .black
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 56)
        ])

        view.addSubview(homeButton)
        NSLayoutConstraint.activate([
            homeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            homeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            homeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            homeButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -25),
            retryButton.heightAnchor.constraint(equalToConstant: 30),
            retryButton.widthAnchor.constraint(equalToConstant: 65),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        view.addSubview(cardImageView)
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15),
            cardImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            cardImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            cardImageView.widthAnchor.constraint(equalTo: cardImageView.heightAnchor,
                                                 multiplier: 1/CardAngle.angle90.boundingBoxRatio)
        ])

        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 40),
            descriptionLabel.widthAnchor.constraint(equalTo: cardImageView.widthAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc
    private func retry() {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func goHome() {
        if let faceVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            navigationController?.popToViewController(faceVC, animated: true)
        }
    }
}
