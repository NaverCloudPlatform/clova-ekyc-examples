/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreMedia
import UIKit

import ClovaEyeD
import Lottie

final class eKYCFaceLivenessViewController: UIViewController {

    private let selectedMotion = Configuration.eKYCSeledctedMotion
    private let cameraResolution = CameraResolution.hd1280x720
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

    private let maskView: MaskView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.1)
        return $0
    }(MaskView())

    private let guideView: FaceGuideView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(FaceGuideView())

    private lazy var checkLabel: CheckLabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = selectedMotion.description
        $0.isChecked = false
        return $0
    }(CheckLabel())

    private lazy var animationView: AnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        let name = selectedMotion.lottieName
        $0.animation = Animation.named(name)
        $0.loopMode = .loop
        return $0
    }(AnimationView())
}

extension eKYCFaceLivenessViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        previewView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
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

extension eKYCFaceLivenessViewController {

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

        let emptyView = UIView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.backgroundColor = .clear
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: guideView.bottomAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])

        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: 30),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 120),
            animationView.widthAnchor.constraint(equalToConstant: 120)
        ])

        view.addSubview(checkLabel)
        NSLayoutConstraint.activate([
            checkLabel.bottomAnchor.constraint(equalTo: animationView.topAnchor, constant: -20),
            checkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
            let poseCondition: Bool
            let YCondition: Bool
            let sizeCondition: Bool
            let boundingSize = $0.boundingBox.width * $0.boundingBox.height
            switch selectedMotion {
            case .mouthOpen, .eyeBlink:
                poseCondition = ($0.pose == .front)
                let centerY = $0.boundingBox.minY + ($0.boundingBox.height / 2)
                YCondition = centerY > cropCenterY
                sizeCondition = boundingSize >= cropRectSize * 0.2
            case .nod, .roll, .shake:
                poseCondition = true
                YCondition = true
                sizeCondition = boundingSize >= cropRectSize * 0.1
            }

            let mouthCondition = !$0.occlusions.mouthOccluded
            let noseCondition = !$0.occlusions.noseOccluded
            return boxCondition && poseCondition && mouthCondition && noseCondition && sizeCondition && YCondition
        }

        if let detectedFace = detectedFaces.first, detectedFaces.count == 1 {
            guideView.showGreenBorder()
            checkLiveness(with: detectedFace)
        } else {
            guideView.showGrid()
        }
    }

    private func checkLiveness(with face: ClovaFace) {
        guard let liveFace = Configuration.eKYCLiveFace else { return }
        let similarity = ClovaFaceDetector.getSimilarity(liveFace, face)
        guard similarity >= 0.35 else { return }
        let livenessChecked: Bool
        switch selectedMotion {
        case .eyeBlink:
            livenessChecked = face.motions.eyeBlink
        case .mouthOpen:
            livenessChecked = face.motions.mouthOpen
        case .nod:
            livenessChecked = face.motions.headNod
        case .roll:
            livenessChecked = face.motions.headRoll
        case .shake:
            livenessChecked = face.motions.headShake
        }

        if livenessChecked {
            checkLabel.isChecked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                let vc = eKYCFaceResultViewController()
                self?.pushIfAvailable(vc, animated: false)
            })
        }
    }

    private func detectFace(with image: ClovaVisionImage) {
        let result = ClovaManager.shared.faceDetector.detectFace(image)
        DispatchQueue.main.async { [weak self] in
            self?.handle(result: result)
        }
    }
}

extension eKYCFaceLivenessViewController: VideoPreviewLayerViewDelegate {

    func captureOutput(_ view: VideoPreviewLayerView, sampleBuffer: CMSampleBuffer) {
        guard let visionImage = ClovaVisionImage(sampleBuffer: sampleBuffer) else { return }
        detectFace(with: visionImage)
    }
}

