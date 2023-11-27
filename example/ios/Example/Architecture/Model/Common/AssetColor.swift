/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

enum AssetColor: String {
    case clovaGreen
    case clovaRed
    case clovaBlue
    case clovaBlack
    case gray1
    case gray2
    case gray3
    case gray4
    case gray5
    case gray6
    case gray7
    case gray8
    case gray9
    case gray10
    case gray11

    var uiColor: UIColor? {
        return UIColor(named: rawValue)
    }
}
