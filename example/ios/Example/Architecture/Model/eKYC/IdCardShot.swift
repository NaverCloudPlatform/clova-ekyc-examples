/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

import ClovaEyeD
import Lottie

enum IdCardShot {
    case front
    case side
    case back

    var guideText: String {
        switch self {
        case .front:
            return "Recognize the front of the card.\nPlease put your ID card in the guide."
        case .side:
            return "Recognize the side of the card.\nTilt the card slowly to fit the square."
        case .back:
            return "Recognize the back of the card.\nPlease put your ID card in the guide."
        }
    }

    var faceLocation: ClovaIdFaceLocation {
        switch self {
        case .front, .side:
            return Configuration.eKYCIdFaceLocation
        case .back:
            return .none
        }
    }

    var cardAngle: CardAngle {
        switch self {
        case .front, .back:
            return .angle90
        case .side:
            return .angle105
        }
    }

    var angleOffset: Int32 {
        switch self {
        case .front, .back:
            return 5
        case .side:
            return 7
        }
    }

    var gridImage: UIImage? {
        switch self {
        case .front, .side:
            switch faceLocation {
            case .left:
                return cardAngle.leftFaceImage
            case .right:
                return cardAngle.rightFaceImage
            default:
                return cardAngle.gridImage
            }
        case .back:
            return AssetImage.angle_90_white_back.uiImage
        }
    }

    var guideAnimation: Animation? {
        switch self {
        case .front, .back:
            return nil
        case .side:
            return Animation.named("EyeD_card_tilt_down")
        }
    }
}
