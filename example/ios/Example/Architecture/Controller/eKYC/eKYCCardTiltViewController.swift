/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreMedia
import UIKit

import ClovaEyeD

final class eKYCCardTiltViewController: eKYCCardShotViewController {

    override var cardShot: IdCardShot {
        return .side
    }

    override func handleAvailableResult(_ result: ClovaIdCardShot) {
        guard let faceImage = result.faceInfo?.faceImage,
              let face1 = Configuration.eKYCCardFace,
              let face2 = ClovaManager.shared.faceDetector.detectFace(faceImage).faces.first else {
            return
        }

        let similarity = ClovaFaceDetector.getSimilarity(face1, face2)
        if similarity < Configuration.eKYCIdCardSimilarity {
            showRetakeAlert(error: .face)
            return
        }

        let vc = eKYCCardTiltCheckViewController(cardImage: result.originImage.uiImage())
        pushIfAvailable(vc, animated: false)
        reset()
    }
}
