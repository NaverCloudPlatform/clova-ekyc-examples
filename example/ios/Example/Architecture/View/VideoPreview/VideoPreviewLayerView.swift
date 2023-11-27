/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import AVFoundation
import UIKit

protocol VideoPreviewLayerViewDelegate: AnyObject {
    func captureOutput(_ view: VideoPreviewLayerView, sampleBuffer: CMSampleBuffer)
}

final class VideoPreviewLayerView: UIView {

    weak var delegate: VideoPreviewLayerViewDelegate?

    private let captureQueue = DispatchQueue(label: "output.queue")
    private var captureSession: AVCaptureSession?
    private var captureOutput: AVCaptureVideoDataOutput?
    private var deviceInput: AVCaptureDeviceInput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var focusToSet: CGPoint?
    private var lastBufferTime: TimeInterval = .zero
    private var maximumFps: Int?

    override func layoutSubviews() {
        updateLayoutIfNeeded()
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    deinit {
        deinitialize()
    }
}

extension VideoPreviewLayerView {

    var isInitialized: Bool {
        return (captureSession?.isRunning == true)
    }

    var isHDREnabled: Bool {
        return (deviceInput?.device.isVideoHDREnabled == true)
    }

    var isHDRSupported: Bool {
        return (deviceInput?.device.activeFormat.isVideoHDRSupported == true)
    }

    @discardableResult
    func initialize(position: AVCaptureDevice.Position = .back,
                    resolution: CameraResolution = .hd1280x720,
                    hdrMode: CameraHDRMode = .auto,
                    useUltraWideIfNeeded: Bool = false,
                    maximumFps: Int? = nil) -> Bool {
        self.maximumFps = maximumFps
        guard captureSession.isNil else {
            return true
        }

        let newSession = AVCaptureSession()
        let newOutput = AVCaptureVideoDataOutput()
        newSession.beginConfiguration()
        newSession.sessionPreset = resolution.preset
        let wideAngleCam = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: position)
        guard let device = wideAngleCam else {
            return false
        }

        var input = try? AVCaptureDeviceInput(device: device)
        if #available(iOS 15.0, *), useUltraWideIfNeeded {
            let deviceMinimumFocusDistance = input?.device.minimumFocusDistance ?? 0
            let ultraWideCam = AVCaptureDevice.default(.builtInUltraWideCamera,
                                                       for: .video,
                                                       position: position)
            // 14 프로 모델 이상의 경우 초점거리 문제로 카드를 기울이는 화면에서 포커싱 문제가 있어 광각렌즈 사용
            // 단, 카드를 90도 이하로 잡는 경우에는, 너무 많은 왜곡이 생겨 아예 카드비율이 깨지므로 일반렌즈 사용
            if deviceMinimumFocusDistance > 150, let optical = ultraWideCam {
                input = try? AVCaptureDeviceInput(device: optical)
            }
        }

        guard let videoDeviceInput = input,
              newSession.canAddInput(videoDeviceInput)
        else {
            return false
        }

        newSession.addInput(videoDeviceInput)
        newOutput.videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA)
        ]

        newOutput.alwaysDiscardsLateVideoFrames = true
        newOutput.setSampleBufferDelegate(self, queue: captureQueue)
        guard newSession.canAddOutput(newOutput) else {
            return false
        }

        newSession.addOutput(newOutput)
        guard let connection = newOutput.connection(with: .video),
              connection.isVideoOrientationSupported
        else {
            return false
        }

        if connection.isVideoMirroringSupported, position == .front {
            connection.isVideoMirrored = true
        }

        connection.videoOrientation = .portrait
        newSession.commitConfiguration()
        let previewLayer = AVCaptureVideoPreviewLayer(session: newSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = frame
        layer.addSublayer(previewLayer)
        videoPreviewLayer = previewLayer
        if videoDeviceInput.device.activeFormat.isVideoHDRSupported {
            do {
                try device.lockForConfiguration()
                switch hdrMode {
                case .auto:
                    device.automaticallyAdjustsVideoHDREnabled = true
                case .on:
                    device.automaticallyAdjustsVideoHDREnabled = false
                    device.isVideoHDREnabled = true
                case .off:
                    device.automaticallyAdjustsVideoHDREnabled = false
                    device.isVideoHDREnabled = false
                }

                device.unlockForConfiguration()
            } catch {
                print("ERROR: \(String(describing: error.localizedDescription))")
            }
        }

        DispatchQueue.global().async {
            newSession.startRunning()
        }

        captureSession = newSession
        captureOutput = newOutput
        deviceInput = videoDeviceInput
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionInterruptionEnded),
                                               name: .AVCaptureSessionInterruptionEnded,
                                               object: newSession)
        return true
    }

    func updateLayoutIfNeeded() {
        CALayer.performWithoutAnimation() {
            videoPreviewLayer?.frame = bounds
        }
    }

    func setFocusPoint(_ point: CGPoint) {
        guard let device = deviceInput?.device,
              device.isFocusPointOfInterestSupported,
              device.isFocusModeSupported(.continuousAutoFocus),
              isInitialized else {
            return
        }

        do{
            try device.lockForConfiguration()
            if device.isAutoFocusRangeRestrictionSupported {
                device.autoFocusRangeRestriction = AVCaptureDevice.AutoFocusRangeRestriction.none
            }

            device.focusPointOfInterest = point
            device.focusMode = .continuousAutoFocus
            device.unlockForConfiguration()
            focusToSet = point
        }
        catch{
            print("ERROR: \(String(describing: error.localizedDescription))")
        }
    }

    func deinitialize() {
        guard !captureSession.isNil else {
            return
        }

        if captureSession?.isRunning == true {
            captureSession?.stopRunning()
        }

        deviceInput = nil
        captureOutput = nil
        captureSession = nil
        focusToSet = nil
        videoPreviewLayer?.session = nil
        videoPreviewLayer = nil
        removeAllSublayers()
        NotificationCenter.default.removeObserver(self)
    }
}

extension VideoPreviewLayerView {

    @objc
    private func sessionInterruptionEnded() {
        if let focusPoint = focusToSet {
            setFocusPoint(focusPoint)
        }
    }
}

extension VideoPreviewLayerView: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !isInitialized || deviceInput?.device.isAdjustingFocus == true {
            return
        }

        if let fps = maximumFps {
            let now = Date().timeIntervalSince1970
            let fps = 1.0 / Double(fps)
            guard fps <= now - lastBufferTime else {
                return
            }

            lastBufferTime = now
        }

        delegate?.captureOutput(self, sampleBuffer: sampleBuffer)
    }
}
