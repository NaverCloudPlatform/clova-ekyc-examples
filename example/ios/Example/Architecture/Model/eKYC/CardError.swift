/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

enum CardError {
    case shape
    case blur
    case glare
    case dark
    case face

    var title: String {
        switch self {
        case .shape:
            return "Documents could not be verified."
        case .glare:
            return "Glare is detected."
        case .blur:
            return "Image is blurred."
        case .dark:
            return "Image is too dark."
        case .face:
            return "Different from the front ID Card."
        }
    }

    var subtitle: String {
        switch self {
        case .shape:
            return "Put documents and smartphones in parallel."
        case .glare:
            return "Please avoid the direct light."
        case .blur:
            return "Please try again."
        case .dark:
            return "Please take a picture in a brighter place."
        case .face:
            return "Please put the right ID Card."
        }
    }
}
