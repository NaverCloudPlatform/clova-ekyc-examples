/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

final class eKYCCardTiltCheckViewController: eKYCCardCheckViewController {

    override var guideImage: UIImage? {
        return AssetImage.double_check_card_tilt.uiImage
    }

    override func moveNextStep() {
        let vc = eKYCCardBackViewController()
        pushIfAvailable(vc)
    }
}
