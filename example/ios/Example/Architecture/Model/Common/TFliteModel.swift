/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import Foundation

enum TFLiteModel {
    case detector
    case landmarker
    case recognizer
    case maskDetector
    case spoofingDetector

    var modelPath: String? {
        return Bundle.main.path(forResource: "\(self.name)", ofType: "model")
    }

    var name: String {
        switch self {
        case .detector:
            return "face_detection_video_1.0.0"
        case .landmarker:
            return "face_landmark_video_1.0.0"
        case .recognizer:
            return "face_recognition_video_1.0.0"
        case .maskDetector:
            return "mask_classification_video_1.0.0"
        case .spoofingDetector:
            return "spoof_classification_video_1.0.0"
        }
    }
}
