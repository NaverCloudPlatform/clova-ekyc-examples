/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

import ClovaEyeD

final class Configuration {

    static let humanCheckThreshold: Double = 0.35
    
    // eKYC Option
    static let eKYCIdCardSimilarity: Float = 0.25
    static var eKYCProcessingStep: eKYCStep = eKYCStep.all
    static var eKYCIdFaceLocation = ClovaIdFaceLocation.anyWhere
    static var eKYCMotionSpoofing = [MotionSpoofing.eyeBlink]
    static var eKYCSimilarityThreshold: Double = 0.65
    static var eKYCCardFace: ClovaFace?
    static var eKYCLiveFace: ClovaFace?
    static var eKYCCardImage: UIImage?
    static var eKYCCardFaceImage: UIImage?
    static var eKYCLiveFaceImage: UIImage?
    static var eKYCSeledctedMotion: MotionSpoofing {
        return eKYCMotionSpoofing.randomElement() ?? .eyeBlink
    }
}
