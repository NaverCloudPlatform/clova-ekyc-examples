/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

enum MotionSpoofing {
    case eyeBlink
    case mouthOpen
    case nod
    case roll
    case shake

    var description: String {
        switch self {
        case .nod:
            return "Nod your head"
        case .roll:
            return "Roll your head left to the right"
        case .shake:
            return "Look at your left to the right"
        case .mouthOpen:
            return "Open your mouth"
        case .eyeBlink:
            return "Blink your eyes"
        }
    }

    var lottieName: String {
        switch self {
        case .nod:
            return "EyeD_motion_nod"
        case .roll:
            return "EyeD_motion_roll"
        case .shake:
            return "EyeD_motion_shake"
        case .mouthOpen:
            return "EyeD_motion_mouth"
        case .eyeBlink:
            return "EyeD_motion_eye_blink"
        }
    }
}
