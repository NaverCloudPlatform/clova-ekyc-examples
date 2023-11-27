/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreMedia
import UIKit

import ClovaEyeD

final class eKYCFaceShotViewController: UIViewController {

    private let cameraResolution = CameraResolution.hd1280x720
    private var lastVisionImage: ClovaVisionImage?
    private var lastDetectedFace: ClovaFace?
    private var cropRect: CGRect = .zero

    private lazy var headerView: NavigationHeaderView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        return $0
    }(NavigationHeaderView(title: "Face Check"))

    private let previewView: VideoPreviewLayerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(VideoPreviewLayerView())


    private let stillImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())

    private let maskView: MaskView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.1)
        return $0
    }(MaskView())

    private let guideView: FaceGuideView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(FaceGuideView())

    private let guideLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "Now we start face recognition step.\nRecognizing your front face."
        return $0
    }(UILabel())

    private lazy var shootButton: ShootButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(tapShootButton))
        return $0
    }(ShootButton())

    private let timerView: TimerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(TimerView())

    private let cameraClickView: CameraClickAnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(CameraClickAnimationView())
}

extension eKYCFaceShotViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        previewView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewView.initialize(
            position: .front,
            resolution: cameraResolution
        )
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        previewView.deinitialize()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeCaptureViewTransparent()
        adjustCropRect()
    }
}

extension eKYCFaceShotViewController {

    private func configureLayout() {
        view.backgroundColor = AssetColor.clovaBlack.uiColor
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(previewView)
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewView.leftAnchor.constraint(equalTo: view.leftAnchor),
            previewView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(stillImageView)
        NSLayoutConstraint.activate([
            stillImageView.topAnchor.constraint(equalTo: view.topAnchor),
            stillImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stillImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stillImageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(maskView)
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: view.topAnchor),
            maskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maskView.leftAnchor.constraint(equalTo: view.leftAnchor),
            maskView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(guideView)
        NSLayoutConstraint.activate([
            guideView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            guideView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            guideView.widthAnchor.constraint(equalTo: guideView.heightAnchor, multiplier: 0.75)
        ])

        view.addSubview(timerView)
        NSLayoutConstraint.activate([
            timerView.topAnchor.constraint(equalTo: guideView.topAnchor),
            timerView.bottomAnchor.constraint(equalTo: guideView.bottomAnchor),
            timerView.leftAnchor.constraint(equalTo: guideView.leftAnchor),
            timerView.rightAnchor.constraint(equalTo: guideView.rightAnchor)
        ])

        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.topAnchor.constraint(equalTo: guideView.bottomAnchor, constant: 20),
            guideLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 44),
            guideLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -44)
        ])

        view.addSubview(shootButton)
        NSLayoutConstraint.activate([
            shootButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            shootButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            shootButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        view.addSubview(cameraClickView)
        NSLayoutConstraint.activate([
            cameraClickView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraClickView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraClickView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraClickView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.bringSubviewToFront(headerView)
    }

    private func makeCaptureViewTransparent() {
        let path = UIBezierPath(rect: guideView.layer.frame)
        maskView.makeMask(with: path)
    }

    private func adjustCropRect() {
        let guideFrame = guideView.frame
        var newRect = guideFrame.changeScale(
            to: cameraResolution.size,
            parentScreenSize: view.frame.size,
            aspectType: .fit)
        newRect.add(margin: 60)
        cropRect = newRect
    }

    private func handle(result: ClovaFaceResult) {
        let cropRectSize = cropRect.width * cropRect.height
        let cropCenterY = cropRect.minY + (cropRect.height / 2)
        let detectedFaces = result.faces.filter {
            let boxCondition = cropRect.contains($0.boundingBox)
            let poseCondition = ($0.pose == .front)
            let mouthCondition = !$0.occlusions.mouthOccluded
            let noseCondition = !$0.occlusions.noseOccluded
            let boundingSize = $0.boundingBox.width * $0.boundingBox.height
            let sizeCondition = boundingSize >= cropRectSize * 0.2
            let centerY = $0.boundingBox.minY + ($0.boundingBox.height / 2)
            let YCondition = centerY > cropCenterY
            return boxCondition && poseCondition && mouthCondition && noseCondition && sizeCondition && YCondition
        }

        if let detectedFace = detectedFaces.first, detectedFaces.count == 1 {
            guideView.showGreenBorder()
            shootButton.isEnabled = true
            lastDetectedFace = detectedFace
        } else {
            guideView.showGrid()
            shootButton.isEnabled = false
            timerView.cancel()
        }
    }

    private func detectFace(with image: ClovaVisionImage) {
        let result = ClovaManager.shared.faceDetector.detectFace(image)
        DispatchQueue.main.async { [weak self] in
            self?.handle(result: result)
        }
    }

    @objc
    private func tapShootButton() {
        timerView.countDown { [weak self] in
            guard let self else { return }
            guard let detectedFace = self.lastDetectedFace,
                  detectedFace.leftEye.state == .open,
                  detectedFace.rightEye.state == .open,
                  let visionImage = self.lastVisionImage else {
                return
            }

            self.previewView.deinitialize()
            let uiImage = visionImage.uiImage()
            self.stillImageView.image = uiImage
            self.guideView.showGreenBorder()
            self.cameraClickView.click {
                let width = CGFloat(visionImage.width())
                let rect = CGRect(
                    x: .zero, y: .zero, width: width, height: width * 4 / 3)
                let croppedImage = visionImage.crop(with: rect)?.uiImage()
                Configuration.eKYCLiveFace = detectedFace
                Configuration.eKYCLiveFaceImage = uiImage
                let vc = eKYCFaceCheckViewController(faceImage: croppedImage)
                self.pushIfAvailable(vc, animated: false)
                self.stillImageView.image = nil
            }
        }
    }
}

extension eKYCFaceShotViewController: VideoPreviewLayerViewDelegate {

    func captureOutput(_ view: VideoPreviewLayerView, sampleBuffer: CMSampleBuffer) {
        guard let visionImage = ClovaVisionImage(sampleBuffer: sampleBuffer) else { return }
        lastVisionImage = visionImage
        detectFace(with: visionImage)
    }
}
