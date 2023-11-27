/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

import ClovaEyeD

final class eKYCCardBackCheckViewController: eKYCCardCheckViewController {

    override var guideImage: UIImage? {
        return AssetImage.double_check_card_back.uiImage
    }

    override func moveNextStep() {
        guard let image = Configuration.eKYCCardImage else { return }
        processingView.play()
        ClovaManager.shared.document(with: image, completion: { (result) in
            DispatchQueue.main.async { [weak self] in
                self?.processingView.stop()
                switch result {
                case .success(let document):
                    let vc = eKYCIcrCheckViewController(cardImage: image, document: document)
                    self?.pushIfAvailable(vc)
                case .failure(let error):
                    switch error {
                    case .internalServerError(let error):
                        if error.code == "0022" {
                            let alert = UIAlertController(title: "Request domain invalid.", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] (_) in
                                self?.navigationController?.popToRootViewController(animated: true)
                            }))

                            self?.present(alert, animated: true)
                            return
                        }
                    default:
                        break
                    }

                    let vc = eKYCDocumentFailViewController(
                        cardImage: image, message: error.description)
                    self?.pushIfAvailable(vc)
                }
            }
        })
    }
}
