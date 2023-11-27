/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

final class VerifyIdCardDomainViewController: UIViewController {

    private let keyPlaceholder = "Enter the secret key."
    private let urlPlaceholder = "Enter the APIGW Invoke URL."

    private let titleImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = AssetImage.ncp_title.uiImage
        return $0
    }(UIImageView())

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Enter the domain information with the type as ID card."
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 23, weight: 700)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private let subtitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "You can check the domain information in \"Console > Domain > Connect API > View.\""
        $0.textColor = .white.withAlphaComponent(0.5)
        $0.font = UIFont.systemFont(ofSize: 14, weight: 500)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var keyInput: InputTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.set(text: Service.idCardSecretKey)
        $0.buttonClicked = { [weak self] in self?.updateKey() }
        return $0
    }(InputTextField(placeholder: keyPlaceholder))

    private lazy var urlInput: InputTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.set(text: Service.idCardInvokeUrl)
        $0.buttonClicked = { [weak self] in self?.updateUrl() }
        return $0
    }(InputTextField(placeholder: urlPlaceholder))

    private let errorLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = nil
        $0.textColor = AssetColor.clovaRed.uiColor
        $0.font = UIFont.systemFont(ofSize: 15, weight: 500)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var doneButton: DoneButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tapDoneButton))
        return $0
    }(DoneButton())

    private let processingView: ProcessingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ProcessingView())
}

extension VerifyIdCardDomainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        processingView.stop()
    }
}

extension VerifyIdCardDomainViewController {

    private func configureLayout() {
        view.backgroundColor = .black
        view.addSubview(keyInput)
        NSLayoutConstraint.activate([
            keyInput.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            keyInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            keyInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        view.addSubview(urlInput)
        NSLayoutConstraint.activate([
            urlInput.topAnchor.constraint(equalTo: keyInput.bottomAnchor, constant: 20),
            urlInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            urlInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.bottomAnchor.constraint(equalTo: keyInput.topAnchor, constant: -40),
            subtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            subtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -15),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        view.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -25),
            titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 207),
            titleImageView.heightAnchor.constraint(equalToConstant: 23)
        ])

        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: urlInput.bottomAnchor, constant: 15),
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34)
        ])

        view.addSubview(processingView)
        NSLayoutConstraint.activate([
            processingView.topAnchor.constraint(equalTo: view.topAnchor),
            processingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            processingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            processingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func updateKey() {
        let alert = UIAlertController(title: keyPlaceholder, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = Service.idCardSecretKey
        alert.textFields?.first?.clearButtonMode = .always
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
            let text = (alert.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            Service.idCardSecretKey = text
            self?.keyInput.set(text: text)
        }))

        present(alert, animated: true)
    }

    private func updateUrl() {
        let alert = UIAlertController(title: urlPlaceholder, message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = Service.idCardInvokeUrl
        alert.textFields?.first?.clearButtonMode = .always
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
            let text = (alert.textFields?.first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            Service.idCardInvokeUrl = text
            self?.urlInput.set(text: text)
        }))

        present(alert, animated: true)
    }

    @objc
    private func tapDoneButton() {
        if (Service.idCardInvokeUrl.isEmpty || Service.idCardSecretKey.isEmpty) {
            let text = "Enter the secret Key and APIGW invoke url."
            errorLabel.text = text
            return
        }

        processingView.play()
        ClovaLicenseChecker.shared().verify(invokeUrl: Service.idCardInvokeUrl,
                                            secretKey: Service.idCardSecretKey,
                                            completion: { [weak self] (result) in
            DispatchQueue.main.async {
                self?.processingView.stop()
                switch result {
                case .success:
                    self?.showNextVC()
                    self?.errorLabel.text = nil
                case .networkNotConnect, .networkTimeout, .invalidServerURL:
                    let text = "Failed to communicate with the server."
                    self?.errorLabel.text = text
                default:
                    let text = "Domain information does not match."
                    self?.errorLabel.text = text
                }
            }
        })

    }

    private func showNextVC() {
        let title = "Would you like to set the face domain information now? "
        let message = "You can set the face recognition domain information in the menu."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Set now", style: .default, handler: { [weak self] (_) in
            let vc = VerifyFaceDomainViewController()
            self?.pushIfAvailable(vc)
        }))

        alert.addAction(UIAlertAction(title: "Set later", style: .default, handler: { [weak self] (_) in
            let vc = HomeViewController()
            self?.pushIfAvailable(vc)
        }))

        present(alert, animated: true)
    }
}
