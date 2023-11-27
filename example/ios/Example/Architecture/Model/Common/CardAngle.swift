/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import UIKit

enum CardAngle: Int32 {
    case angle75 = 75
    case angle80 = 80
    case angle85 = 85
    case angle90 = 90
    case angle95 = 95
    case angle100 = 100
    case angle105 = 105

    var boundingBoxRatio: CGFloat {
        switch self {
        case .angle75:
            return 129/315
        case .angle80:
            return 152/315
        case .angle85:
            return 187/315
        case .angle90:
            return 194/307
        case .angle95:
            return 168/315
        case .angle100:
            return 140/315
        case .angle105:
            return 116/315
        }
    }

    var tiltedRatio: CGFloat {
        switch self {
        case .angle75:
            return 31/315
        case .angle80:
            return 26/315
        case .angle85:
            return 16.3/315
        case .angle90:
            return 0
        case .angle95:
            return 16.5/315
        case .angle100:
            return 25.7/315
        case .angle105:
            return 31/315
        }
    }

    var gridImage: UIImage? {
        switch self {
        case .angle75:
            return AssetImage.angle_75_white.uiImage
        case .angle80:
            return AssetImage.angle_80_white.uiImage
        case .angle85:
            return AssetImage.angle_85_white.uiImage
        case .angle90:
            return AssetImage.angle_90_white.uiImage
        case .angle95:
            return AssetImage.angle_95_white.uiImage
        case .angle100:
            return AssetImage.angle_100_white.uiImage
        case .angle105:
            return AssetImage.angle_105_white.uiImage
        }
    }

    var redBorderImage: UIImage? {
        switch self {
        case .angle75:
            return AssetImage.angle_75_red.uiImage
        case .angle80:
            return AssetImage.angle_80_red.uiImage
        case .angle85:
            return AssetImage.angle_85_red.uiImage
        case .angle90:
            return AssetImage.angle_90_red.uiImage
        case .angle95:
            return AssetImage.angle_95_red.uiImage
        case .angle100:
            return AssetImage.angle_100_red.uiImage
        case .angle105:
            return AssetImage.angle_105_red.uiImage
        }
    }

    var greenBorderImage: UIImage? {
        switch self {
        case .angle75:
            return AssetImage.angle_75_green.uiImage
        case .angle80:
            return AssetImage.angle_80_green.uiImage
        case .angle85:
            return AssetImage.angle_85_green.uiImage
        case .angle90:
            return AssetImage.angle_90_green.uiImage
        case .angle95:
            return AssetImage.angle_95_green.uiImage
        case .angle100:
            return AssetImage.angle_100_green.uiImage
        case .angle105:
            return AssetImage.angle_105_green.uiImage
        }
    }

    var leftFaceImage: UIImage? {
        switch self {
        case .angle75:
            return AssetImage.angle_75_white_left.uiImage
        case .angle80:
            return AssetImage.angle_80_white_left.uiImage
        case .angle85:
            return AssetImage.angle_85_white_left.uiImage
        case .angle90:
            return AssetImage.angle_90_white_left.uiImage
        case .angle95:
            return AssetImage.angle_95_white_left.uiImage
        case .angle100:
            return AssetImage.angle_100_white_left.uiImage
        case .angle105:
            return AssetImage.angle_105_white_left.uiImage
        }
    }

    var rightFaceImage: UIImage? {
        switch self {
        case .angle75:
            return AssetImage.angle_75_white_right.uiImage
        case .angle80:
            return AssetImage.angle_80_white_right.uiImage
        case .angle85:
            return AssetImage.angle_85_white_right.uiImage
        case .angle90:
            return AssetImage.angle_90_white_right.uiImage
        case .angle95:
            return AssetImage.angle_95_white_right.uiImage
        case .angle100:
            return AssetImage.angle_100_white_right.uiImage
        case .angle105:
            return AssetImage.angle_105_white_right.uiImage
        }
    }
}
