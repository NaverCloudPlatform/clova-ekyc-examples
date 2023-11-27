/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

class eKYCCardCheckViewController: UIViewController {

    var guideImage: UIImage? {
        return nil
    }

    let headerLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 17, weight: 700)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.text = "Double Checking"
        return $0
    }(UILabel())

    let contentImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        return $0
    }(UIImageView())

    lazy var guideImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        $0.image = guideImage
        return $0
    }(UIImageView())

    lazy var retryButton: RetryButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(retry))
        return $0
    }(RetryButton())

    lazy var nextButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = AssetColor.clovaGreen.uiColor
        $0.tintColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.setTitle("Move to Next Step", for: .normal)
        $0.makeRoundBorder(radius: 3)
        $0.addTarget(self, action: #selector(moveNextStep))
        return $0
    }(UIButton())

    let processingView: ProcessingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ProcessingView())

    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(UIScrollView())

    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(UIView())

    init(cardImage: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        contentImageView.image = cardImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func moveNextStep() { }
}

extension eKYCCardCheckViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

extension eKYCCardCheckViewController {

    private func configureLayout() {
        view.backgroundColor = AssetColor.clovaBlack.uiColor
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 56)
        ])

        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
            nextButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addSubview(retryButton)
        NSLayoutConstraint.activate([
            retryButton.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -25),
            retryButton.heightAnchor.constraint(equalToConstant: 30),
            retryButton.widthAnchor.constraint(equalToConstant: 65),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            scrollView.bottomAnchor.constraint(
                equalTo: retryButton.topAnchor, constant: -35),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentView.addSubview(contentImageView)
        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 25),
            contentImageView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor, constant: 34),
            contentImageView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor, constant: -34),
        ])

        if let image = contentImageView.image {
            let ratio = image.size.height / image.size.width
            NSLayoutConstraint.activate([
                contentImageView.heightAnchor.constraint(
                    equalTo: contentImageView.widthAnchor,
                    multiplier: ratio)
            ])
        }

        contentView.addSubview(guideImageView)
        NSLayoutConstraint.activate([
            guideImageView.topAnchor.constraint(
                equalTo: contentImageView.bottomAnchor, constant: 40),
            guideImageView.leftAnchor.constraint(
                equalTo: contentView.leftAnchor, constant: 44),
            guideImageView.rightAnchor.constraint(
                equalTo: contentView.rightAnchor, constant: -44),
            guideImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -20)
        ])

        if let image = guideImage {
            let ratio = image.size.height / image.size.width
            NSLayoutConstraint.activate([
                guideImageView.heightAnchor.constraint(
                    equalTo: contentImageView.widthAnchor,
                    multiplier: ratio)
            ])
        }

        view.addSubview(processingView)
        NSLayoutConstraint.activate([
            processingView.topAnchor.constraint(equalTo: view.topAnchor),
            processingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            processingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            processingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        processingView.stop()
    }

    @objc
    private func retry() {
        navigationController?.popViewController(animated: true)
    }
}
