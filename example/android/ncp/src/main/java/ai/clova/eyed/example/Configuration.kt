/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example


import ai.clova.eyed.api.ncp.data.CompareResult
import ai.clova.eyed.api.ncp.data.DocumentResult
import ai.clova.eyed.api.ncp.data.VerifyResult
import ai.clova.eyed.card.ClovaIdCardDetectorOption
import android.graphics.Bitmap
import ai.clova.eyed.card.data.ClovaIdCardShot
import ai.clova.eyed.example.result.FaceScanResult
import ai.clova.eyed.face.data.ClovaFace

object Configuration {
    // Face Settings
    var faceBoundingBox: Boolean = true
    var faceLandmark: Boolean = true
    var faceSpoofing: Boolean = false
    var faceSpoofingThreshold: Float = 0.1F

    // Face Compare
    var isServerMode: Boolean = false

    // Card Settings
    var checkSideDetected: Boolean = false

    // Id Card Settings
    var idCardDetectorOption: ClovaIdCardDetectorOption = ClovaIdCardDetectorOption(
        checkGlareDetected = true,
        checkImageBlurry = true,
        checkCameraShaky = true,
        checkImageDark = true
    )

    // ID Card
    var idCardInvokeUrl: String = ""
    var idCardSecretKey: String = ""
    var faceInvokeUrl: String = ""
    var faceSecretKey: String = ""

    var documentResult: DocumentResult? = null
    var verifyResult: VerifyResult? = null

    var autoCaptureTimeLimit: Long = 30000
    var cardScanFrontFace: ClovaFace? = null
    var cardScanFrontResult: ClovaIdCardShot? = null
    var cardScanTiltResult: ClovaIdCardShot? = null
    var cardScanBackResult: ClovaIdCardShot? = null
    var edgeSimilarityThreshold: Float = 0.25f
    var cardAccumulateCount: Int = 5

    // Face Scan
    var faceScanResult: FaceScanResult? = null
    var facePreviewImage: Bitmap? = null
    var compareResult: CompareResult? = null
    var similarityThreshold: Float = 0.65f
    var humanCheckThreshold: Float = 0.35f
    var ekycSelectedMotion: Motion = Motion.EYE_BLINK
    var ekycFaceLocation: ClovaIdCardDetectorOption.IdFaceLocation = ClovaIdCardDetectorOption.IdFaceLocation.ANY_WHERE

    //  Motion
    enum class Motion {
        EYE_BLINK,
        MOUTH_OPEN,
        HEAD_SHAKE,
        HEAD_ROLL,
        HEAD_NOD
    }

    //  Motion
    var selectedMotion: Motion = Motion.EYE_BLINK

    enum class ClovaeyesModel(val value: String) {
        ClovaEyesDetector("clovaeyes/face_detection_video_1.0.0.model"),
        ClovaEyesLandmarker("clovaeyes/face_landmark_video_1.0.0.model"),
        ClovaEyesMaskClassifier("clovaeyes/mask_classification_video_1.0.0.model"),
        ClovaEyesSpoofClassifier("clovaeyes/spoof_classification_video_1.0.0.model"),
        ClovaEyesRecognizer("clovaeyes/face_recognition_video_1.0.0.model")
    }

    var scenarioMode = ScenarioMode.VERIFY_COMPARE
    var isDebugMode = false

    enum class ScenarioMode {
        VERIFY_COMPARE,
        VERIFY,
        COMPARE
    }
}