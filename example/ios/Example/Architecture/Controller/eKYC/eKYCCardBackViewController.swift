/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreMedia
import UIKit

import ClovaEyeD

final class eKYCCardBackViewController: eKYCCardShotViewController {

    override var cardShot: IdCardShot {
        return .back
    }

    override func handleAvailableResult(_ result: ClovaIdCardShot) {
        let vc = eKYCCardBackCheckViewController(cardImage: result.originImage.uiImage())
        pushIfAvailable(vc, animated: false)
        reset()
    }
}
