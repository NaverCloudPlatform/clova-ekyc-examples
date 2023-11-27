/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class eKYCCardFrontCheckViewController: eKYCCardCheckViewController {

    override var guideImage: UIImage? {
        return AssetImage.double_check_card_front.uiImage
    }

    override func moveNextStep() {
        switch Configuration.eKYCProcessingStep {
        case .all, .verify:
            let vc = eKYCCardTiltViewController()
            pushIfAvailable(vc)
        case .faceComapre:
            let vc = eKYCFaceShotViewController()
            pushIfAvailable(vc)
        }
    }
}
