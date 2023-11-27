/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreMedia
import UIKit

import ClovaEyeD

final class eKYCCardFrontViewController: eKYCCardShotViewController {

    override var cardShot: IdCardShot {
        return .front
    }

    override func handleAvailableResult(_ result: ClovaIdCardShot) {
        guard let faceImage = result.faceInfo?.faceImage,
              let cardFace = ClovaManager.shared.faceDetector.detectFace(faceImage).faces.first else {
            return
        }

        Configuration.eKYCCardFace = cardFace
        Configuration.eKYCCardFaceImage = result.faceInfo?.faceImage.uiImage()
        Configuration.eKYCCardImage = result.originImage.uiImage()
        let vc = eKYCCardFrontCheckViewController(cardImage: result.originImage.uiImage())
        pushIfAvailable(vc, animated: false)
        reset()
    }
}
