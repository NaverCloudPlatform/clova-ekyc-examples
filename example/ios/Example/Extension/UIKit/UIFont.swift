/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

extension UIFont {

    class func systemFont(ofSize fontSize: CGFloat, weight: Int) -> UIFont {
        switch weight {
        case 900:
            return .systemFont(ofSize: fontSize, weight: .black)
        case 800:
            return .systemFont(ofSize: fontSize, weight: .heavy)
        case 700:
            return .systemFont(ofSize: fontSize, weight: .bold)
        case 600:
            return .systemFont(ofSize: fontSize, weight: .semibold)
        case 500:
            return .systemFont(ofSize: fontSize, weight: .medium)
        case 400:
            return .systemFont(ofSize: fontSize, weight: .regular)
        case 300:
            return .systemFont(ofSize: fontSize, weight: .light)
        case 200:
            return .systemFont(ofSize: fontSize, weight: .thin)
        case 100:
            return .systemFont(ofSize: fontSize, weight: .ultraLight)
        default:
            return .systemFont(ofSize: fontSize, weight: .regular)
        }
    }
}
