/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

import CoreMedia
import UIKit

import ClovaEyeD
import Lottie

class eKYCCardShotViewController: UIViewController {

    var cardShot: IdCardShot {
        return .front
    }

    var cardOption: ClovaIdCardDetectorOption {
        let option = ClovaIdCardDetectorOption()
        option.isHDREnabled = previewView.isHDREnabled
        option.checkSideDetected = false
        option.checkCameraShaky = true
        option.checkImageDark = true
        option.checkImageBlurry = true
        option.checkGlareDeteced = true
        option.glarePercentage = 0.07
        option.accumulatedFrameCount = 10
        option.targetAngle = cardShot.cardAngle.rawValue
        option.faceLocation = cardShot.faceLocation
        option.angleOffset = cardShot.angleOffset
        return option
    }

    private let timer = SourceTimer()
    private let cameraResolution = CameraResolution.hd1920x1080
    private var cropRect: CGRect = .zero
    private var failCount = 0
    private var lastSuccessTime = Date()
    private var lastVisionImage: ClovaVisionImage?
    private var isAutoCaptureMode = true {
        didSet {
            shootButton.isHidden = isAutoCaptureMode
        }
    }

    private let previewView: VideoPreviewLayerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(VideoPreviewLayerView())

    private lazy var headerView: NavigationHeaderView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        return $0
    }(NavigationHeaderView(title: "ID card scanning"))

    private let stillImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())

    private let maskView: MaskView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(MaskView())

    private lazy var guideLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16, weight: 500)
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = cardShot.guideText
        return $0
    }(UILabel())

    private let guideView: CardGuideView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(CardGuideView())

    private lazy var animationView: AnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.animation = cardShot.guideAnimation
        $0.loopMode = .loop
        return $0
    }(AnimationView())

    private lazy var shootButton: ShootButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tapShootButton))
        return $0
    }(ShootButton())

    private let dimmedView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black.withAlphaComponent(0.25)
        return $0
    }(UIView())

    private let cameraClickView: CameraClickAnimationView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(CameraClickAnimationView())

    func handleAvailableResult(_ result: ClovaIdCardShot) { }
}

extension eKYCCardShotViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        guideView.showImage(image: cardShot.gridImage)
        previewView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializePreview()
        updateDetectorOption()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deinitializePreview()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeCaptureViewTransparent()
        adjustCropRect()
    }
}

extension eKYCCardShotViewController {

    func reset() {
       failCount = 0
       isAutoCaptureMode = true
       stillImageView.image = nil
       dimmedView.isHidden = true
       guideView.showImage(image: cardShot.gridImage)
       ClovaManager.shared.idCardDetector.reset()
    }

    func showRetakeAlert(error: CardError) {
        guard navigationController?.visibleViewController == self else { return }
        ClovaManager.shared.idCardDetector.reset()
        timer.stop()
        dimmedView.isHidden = false
        stillImageView.image = lastVisionImage?.uiImage()
        deinitializePreview()
        let vc = AlertViewController(
            icon: AssetImage.icon_warning.uiImage, guideText1: error.title,
            guideText2: error.subtitle, buttonText: "Retake")

        vc.dismissed = { [weak self] in
            guard let self else { return }
            self.failCount += 1
            if self.failCount >= 2, self.isAutoCaptureMode {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.showManualShootAlert()
                })
            } else {
                self.initializePreview()
                self.stillImageView.image = nil
                self.dimmedView.isHidden = true
            }
        }

        present(vc, animated: true)
    }
}

extension eKYCCardShotViewController {

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
            guideView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            guideView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.82),
            guideView.widthAnchor.constraint(
                equalTo: guideView.heightAnchor, multiplier: 1/cardShot.cardAngle.boundingBoxRatio)
        ])

        view.addSubview(guideLabel)
        NSLayoutConstraint.activate([
            guideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideLabel.widthAnchor.constraint(equalTo: guideView.widthAnchor),
            guideLabel.heightAnchor.constraint(equalToConstant: 42),
            guideLabel.bottomAnchor.constraint(equalTo: guideView.topAnchor, constant: -20)
        ])

        view.addSubview(shootButton)
        NSLayoutConstraint.activate([
            shootButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            shootButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34),
            shootButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34),
        ])

        if !cardShot.guideAnimation.isNil {
            let emptyView = UIView()
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.backgroundColor = .clear
            view.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: guideView.bottomAnchor),
                emptyView.bottomAnchor.constraint(equalTo: shootButton.topAnchor),
                emptyView.leftAnchor.constraint(equalTo: view.leftAnchor),
                emptyView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])

            view.addSubview(animationView)
            NSLayoutConstraint.activate([
                animationView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
                animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animationView.widthAnchor.constraint(equalToConstant: 190),
                animationView.heightAnchor.constraint(equalToConstant: 130),
            ])
        }

        view.addSubview(cameraClickView)
        NSLayoutConstraint.activate([
            cameraClickView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraClickView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraClickView.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraClickView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.addSubview(dimmedView)
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leftAnchor.constraint(equalTo: view.leftAnchor),
            dimmedView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(dimmedView)
        reset()
    }

    private func initializePreview() {
        animationView.play()
        guard !previewView.isInitialized else { return }
        ClovaManager.shared.idCardDetector.reset()
        previewView.initialize(
            position: .back,
            resolution: cameraResolution,
            maximumFps: 15
        )

        if isAutoCaptureMode {
            timer.start(timeoutInterval: 30, timeoutBlock: { [weak self] in
                self?.didReceiveScanTimeout()
            })
        } else {
            timer.stop()
        }
    }

    private func deinitializePreview() {
        previewView.deinitialize()
        timer.stop()
    }

    private func didReceiveScanTimeout() {
        DispatchQueue.main.async { [weak self] in
            self?.showManualShootAlert()
        }
    }

    private func updateDetectorOption() {
        ClovaManager.shared.idCardDetector.setOption(cardOption)
    }

    private func adjustCropRect() {
        let guideFrame = guideView.frame
        var newRect = guideFrame.changeScale(
            to: cameraResolution.size,
            parentScreenSize: view.frame.size,
            aspectType: .fit)
        newRect.add(margin: 5)
        cropRect = newRect
    }

    private func makeCaptureViewTransparent() {
        let rect = guideView.layer.frame
        let rectPath = UIBezierPath()
        let height = rect.width * cardShot.cardAngle.boundingBoxRatio
        let tiltedRatio = cardShot.cardAngle.tiltedRatio
        let newRect = CGRect(
            x: rect.origin.x, y: rect.origin.y + (rect.height - height) / 2,
            width: rect.width, height: height)
        var leftTop = CGPoint(x: newRect.minX, y: newRect.minY)
        var rightTop = CGPoint(x: newRect.maxX, y: newRect.minY)
        let leftBottom = CGPoint(x: newRect.minX, y: newRect.maxY)
        let rightBottom = CGPoint(x: newRect.maxX, y: newRect.maxY)
        leftTop.x = leftTop.x + tiltedRatio * newRect.width
        rightTop.x = rightTop.x - tiltedRatio * newRect.width
        rectPath.move(to: leftTop)
        rectPath.addLine(to: rightTop)
        rectPath.addLine(to: rightBottom)
        rectPath.addLine(to: leftBottom)
        rectPath.addLine(to: leftTop)
        rectPath.close()
        maskView.makeMask(with: rectPath)
    }

    private func setFocusPoint() {
        let y = (guideView.frame.origin.x + (guideView.frame.width / 2)) / previewView.frame.width
        let x = (guideView.frame.origin.y + (guideView.frame.width * cardShot.cardAngle.boundingBoxRatio / 2)) / previewView.frame.height
        let centerPoint = CGPoint(x: x, y: y)
        previewView.setFocusPoint(centerPoint)
    }

    private func handle(card: ClovaIdCard, image: ClovaVisionImage) {
        guard previewView.isInitialized else { return }
        if !card.rectInfo.isNil {
            lastSuccessTime = Date()
            guideView.showImage(image: cardShot.cardAngle.greenBorderImage)
            let detector = ClovaManager.shared.idCardDetector
            if isAutoCaptureMode {
                let result = detector.shotIdCard(threshold: 5)
                switch result.status {
                case .blurError:
                    showRetakeAlert(error: .blur)
                case .glareError:
                    showRetakeAlert(error: .glare)
                case .darkError:
                    showRetakeAlert(error: .dark)
                case .available:
                    if let idCard = result.idCard {
                        handleAvailableResult(idCard)
                    }
                default:
                    break
                }
            }
        } else {
            let currentTime = Date()
            let interval = currentTime.timeIntervalSince1970 - lastSuccessTime.timeIntervalSince1970
            if interval > 1 {
                guideView.showImage(image: cardShot.gridImage)
            }
        }
    }

    private func showManualShootAlert() {
        guard navigationController?.visibleViewController == self else { return }
        timer.stop()
        dimmedView.isHidden = false
        stillImageView.image = lastVisionImage?.uiImage()
        deinitializePreview()
        let vc = AlertViewController(
            icon: AssetImage.icon_camera_green.uiImage,
            guideText1: "Can’t read the document\nSwitch to manual capture.",
            guideText2: "Align the document exactly in the frame and take picture without blurring.",
            buttonText: "Shoot manually")
        var buttonTapped = false
        vc.buttonTapped = {
            buttonTapped = true
        }

        vc.dismissed = { [weak self] in
            self?.isAutoCaptureMode = !buttonTapped
            self?.initializePreview()
            self?.stillImageView.image = nil
            self?.dimmedView.isHidden = true
        }

        present(vc, animated: true)
    }

    @objc
    private func tapShootButton() {
        let detector = ClovaManager.shared.idCardDetector
        stillImageView.image = lastVisionImage?.uiImage()
        guideView.showImage(image: cardShot.cardAngle.greenBorderImage)
        cameraClickView.click { [weak self] in
            guard let self else { return }
            let result = detector.shotIdCard(threshold: 1)
            switch result.status {
            case .blurError:
                self.showRetakeAlert(error: .blur)
            case .glareError:
                self.showRetakeAlert(error: .glare)
            case .darkError:
                self.showRetakeAlert(error: .dark)
            case .notAvailable:
                self.showRetakeAlert(error: .shape)
            case .available:
                if let idCard = result.idCard {
                    handleAvailableResult(idCard)
                } else {
                    self.showRetakeAlert(error: .shape)
                }
            default:
                break
            }
        }
    }
}

extension eKYCCardShotViewController: VideoPreviewLayerViewDelegate {

    func captureOutput(_ view: VideoPreviewLayerView, sampleBuffer: CMSampleBuffer) {
        guard let visionImage = ClovaVisionImage(sampleBuffer: sampleBuffer),
              let croppedImage = visionImage.crop(with: cropRect) else { return }
        lastVisionImage = visionImage
        let card = ClovaManager.shared.idCardDetector.detectIdCard(with: croppedImage)
        DispatchQueue.main.async { [weak self] in
            self?.setFocusPoint()
            self?.handle(card: card, image: croppedImage)
        }
    }
}
