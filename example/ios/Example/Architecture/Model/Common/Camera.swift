/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import AVFoundation
import CoreGraphics

enum CameraHDRMode {
    case on
    case off
    case auto
}

enum CameraResolution {
    case vga640x480
    case hd1280x720
    case hd1920x1080

    var size: CGSize {
        switch self {
        case .vga640x480:
            return CGSize(width: 480, height: 640)
        case .hd1280x720:
            return CGSize(width: 720, height: 1280)
        case .hd1920x1080:
            return CGSize(width: 1080, height: 1920)
        }
    }

    var preset: AVCaptureSession.Preset {
        switch self {
        case .vga640x480:
            return .vga640x480
        case .hd1280x720:
            return .hd1280x720
        case .hd1920x1080:
            return .hd1920x1080
        }
    }
}
