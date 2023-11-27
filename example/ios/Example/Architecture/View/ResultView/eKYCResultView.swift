/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class eKYCResultView: UIView {

    var tapRetryButton: (() -> Void)?
    var tapHomeButton: (() -> Void)?

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 26, weight: 700)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 2
        return $0
    }(UILabel())

    private let subtitleLabel1: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 500)
        $0.textColor = .white.withAlphaComponent(0.7)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        return $0
    }(UILabel())

    private let subtitleLabel2: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 500)
        $0.textColor = .white.withAlphaComponent(0.7)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.alpha = 0.7
        return $0
    }(UILabel())

    private let successIconImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.icon_success.uiImage
        return $0
    }(UIImageView())

    private let failureIconImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.icon_failed.uiImage
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
        $0.setTitle("Home", for: .normal)
        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(goHome))
        return $0
    }(UIButton())

    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension eKYCResultView {

    func handleSuccess(similarity: Double, spoofPrediction: Double?) {
        let similarityString = (String(format: "%.2f", similarity))
        successIconImageView.isHidden = false
        failureIconImageView.isHidden = true
        titleLabel.text = "Authentication\r\nSuccess"
        var subtitle = "similarity: \(similarityString)"
        if let prediction = spoofPrediction {
            let predictionString = (String(format: "%.2f",  prediction))
            subtitle += "\r\nspoof prediction: \(predictionString)"
        }

        subtitleLabel1.text = subtitle
        subtitleLabel1.alpha = 0.7
        subtitleLabel2.isHidden = true
    }

    func handleSuccess(spoofPrediction: Float) {
        successIconImageView.isHidden = false
        failureIconImageView.isHidden = true
        titleLabel.text = "Authentication\r\nSuccess"
        let predictionString = (String(format: "%.2f",  spoofPrediction))
        subtitleLabel1.text = "spoof prediction: \(predictionString)"
        subtitleLabel1.alpha = 0.7
        subtitleLabel2.isHidden = true
    }

    func handleError(_ error: eKYCError) {
        successIconImageView.isHidden = true
        failureIconImageView.isHidden = false
        titleLabel.text = "Authentication\r\nOver"
        subtitleLabel1.alpha = 1.0
        switch error {
        case .rgbSpoof(let prediction):
            let predictionString = (String(format: "%.2f",  prediction))
            subtitleLabel1.text = "We had detected the\r\nRGB SPOOF ATTEMPT."
            subtitleLabel2.text = "spoof prediction: \(predictionString)"
            subtitleLabel2.isHidden = false
        case .failToCheckIDCard(let similarity, let spoofPrediction):
            let similarityString = (String(format: "%.2f",  similarity))
            subtitleLabel1.text = "The similarity of ID and the real face is \(similarityString), which is LOWER than the standard."
            if let prediction = spoofPrediction {
                subtitleLabel2.isHidden = false
                let predictionString = (String(format: "%.2f",  prediction))
                subtitleLabel2.text = "spoof prediction: \(predictionString)"
            } else {
                subtitleLabel2.isHidden = true
            }
        case .serverError(let message):
            subtitleLabel1.text =  message ?? "Server connection error"
            subtitleLabel2.isHidden = true
        }
    }

    func handleAmbiguous(similarity: Double, spoofPrediction: Double?) {
        let similarityString = (String(format: "%.2f",  similarity))
        subtitleLabel1.text = "The similarity of ID and the real face is (\(similarityString)), which needs human check."
        successIconImageView.isHidden = false
        failureIconImageView.isHidden = true
        titleLabel.text = "Human check\r\nneeded"
        subtitleLabel1.alpha = 1.0
        if let prediction = spoofPrediction {
            subtitleLabel2.isHidden = false
            let predictionString = (String(format: "%.2f",  prediction))
            subtitleLabel2.text = "spoof prediction: \(predictionString)"
        } else {
            subtitleLabel2.isHidden = true
        }
    }
}

extension eKYCResultView {

    private func configureLayout() {
        backgroundColor = .black.withAlphaComponent(0.7)
        addSubview(homeButton)
        NSLayoutConstraint.activate([
            homeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -34),
            homeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 34),
            homeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -34),
            homeButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -25),
            retryButton.heightAnchor.constraint(equalToConstant: 30),
            retryButton.widthAnchor.constraint(equalToConstant: 65),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
        ])

        addSubview(successIconImageView)
        NSLayoutConstraint.activate([
            successIconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -30),
            successIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            successIconImageView.heightAnchor.constraint(equalToConstant: 59),
            successIconImageView.widthAnchor.constraint(equalToConstant: 80)
        ])

        addSubview(failureIconImageView)
        NSLayoutConstraint.activate([
            failureIconImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -30),
            failureIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            failureIconImageView.heightAnchor.constraint(equalToConstant: 80),
            failureIconImageView.widthAnchor.constraint(equalToConstant: 80)
        ])

        addSubview(subtitleLabel1)
        NSLayoutConstraint.activate([
            subtitleLabel1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel1.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            subtitleLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            subtitleLabel1.heightAnchor.constraint(equalToConstant: 40),
        ])

        addSubview(subtitleLabel2)
        NSLayoutConstraint.activate([
            subtitleLabel2.topAnchor.constraint(equalTo: subtitleLabel1.bottomAnchor, constant: 15),
            subtitleLabel2.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            subtitleLabel2.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
        ])

    }

    @objc
    private func retry() {
        tapRetryButton?()
    }

    @objc
    private func goHome() {
        tapHomeButton?()
    }
}
