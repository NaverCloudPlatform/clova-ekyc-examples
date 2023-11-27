/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

final class eKYCFaceResultViewController: UIViewController {

    private lazy var headerView: NavigationHeaderView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backButton.isHidden = true
        return $0
    }(NavigationHeaderView(title: "Face Check"))

    private let faceImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())

    private let processingView: ProcessingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ProcessingView())

    private lazy var resultView: eKYCResultView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tapRetryButton = retry
        $0.tapHomeButton = goHome
        return $0
    }(eKYCResultView())

    init() {
        super.init(nibName: nil, bundle: nil)
        faceImageView.image = Configuration.eKYCLiveFaceImage
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension eKYCFaceResultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
}

extension eKYCFaceResultViewController {

    private func configureLayout() {
        view.backgroundColor = AssetColor.clovaBlack.uiColor
        view.addSubview(faceImageView)
        NSLayoutConstraint.activate([
            faceImageView.topAnchor.constraint(equalTo: view.topAnchor),
            faceImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            faceImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            faceImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(processingView)
        NSLayoutConstraint.activate([
            processingView.topAnchor.constraint(equalTo: view.topAnchor),
            processingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            processingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            processingView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(resultView)
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: view.topAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            resultView.leftAnchor.constraint(equalTo: view.leftAnchor),
            resultView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        processingView.play()
        resultView.isHidden = true
        compareFace()
    }

    private func compareFace() {
        guard let face1 = Configuration.eKYCCardFaceImage, let face2 = Configuration.eKYCLiveFaceImage else {
            resultView.handleError(.failToCheckIDCard(similarity: 0.0, spoofPrediction: nil))
            return
        }

        ClovaManager.shared.compare(face1: face1, face2: face2, completion: { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.processingView.stop()
                self.view.bringSubviewToFront(headerView)
                switch result {
                case .success(let compareResult):
                    let value = compareResult.similarity
                    if value >= Configuration.eKYCSimilarityThreshold {
                        self.resultView.handleSuccess(similarity: value, spoofPrediction: nil)
                    } else if value < Configuration.humanCheckThreshold {
                        self.resultView.handleError(.failToCheckIDCard(similarity: value, spoofPrediction: nil))
                    } else {
                        self.resultView.handleAmbiguous(similarity: value, spoofPrediction: nil)
                    }
                case .failure(let error):
                    switch error {
                    case .internalServerError(let error):
                        if error.code == "0022" {
                            let alert = UIAlertController(title: "Request domain invalid.", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
                                self?.navigationController?.popToRootViewController(animated: true)
                            }))

                            self.present(alert, animated: true)
                            return
                        }
                    default:
                        break
                    }

                    self.resultView.handleError(.serverError(message: error.description))
                }

                self.resultView.isHidden = false
            }
        })
    }

    private func retry() {
        if let faceVC = navigationController?.viewControllers.first(where: { $0 is eKYCFaceShotViewController }) {
            navigationController?.popToViewController(faceVC, animated: true)
        }
    }

    private func goHome() {
        if let faceVC = navigationController?.viewControllers.first(where: { $0 is HomeViewController }) {
            navigationController?.popToViewController(faceVC, animated: true)
        }
    }
}

