/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.card.ncp.ClovaIdCardDetector
import ai.clova.eyed.card.ClovaIdCardDetectorOption
import ai.clova.eyed.card.data.ClovaIdCardResult
import ai.clova.eyed.card.data.ClovaIdCardShotResult
import ai.clova.eyed.card.data.ClovaIdCardShotStatus
import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.camera.DefaultCameraFragment
import ai.clova.eyed.example.databinding.FragmentIdScanTiltBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.drawBackgroundDimLayer
import ai.clova.eyed.example.utils.drawCardBorderLines
import ai.clova.eyed.example.utils.drawCardCornerIcon
import ai.clova.eyed.example.utils.runOnUiThread
import ai.clova.eyed.face.ncp.ClovaFaceDetector
import ai.clova.eyed.face.ClovaFaceDetectorOption
import ai.clova.eyed.image.ClovaVisionImage
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ObjectAnimator
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.PointF
import android.os.Bundle
import android.os.CountDownTimer
import android.util.Size
import android.view.*
import android.widget.*
import androidx.core.view.isVisible
import androidx.navigation.findNavController
import com.google.android.material.bottomsheet.BottomSheetDialog
import java.util.concurrent.atomic.AtomicReference

class IdCardScanTiltFragment : DefaultCameraFragment() {

    private lateinit var binding: FragmentIdScanTiltBinding

    override val resolution = Size(1080, 1920)

    private lateinit var idCardDetector: ClovaIdCardDetector
    private lateinit var faceDetector: ClovaFaceDetector

    private val cardDetectorState = AtomicReference<CardDetectorState>(CardDetectorState.START)
    private var cardCaptureMode = CardCaptureMode.AUTO_CAPTURE
    private var alertCounts = 0
    private var bottomSheetDialog: BottomSheetDialog? = null
    private var timer: CountDownTimer? = null

    private var idCardResult: ClovaIdCardResult? = null
    private var idCardShotResult: ClovaIdCardShotResult? = null

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")
        return super.onCreateView(inflater, container, savedInstanceState)
    }

    override fun onDestroyView() {
        debug(tag = TAG, message = "onDestroyView")
        super.onDestroyView()
    }

    override fun onResume() {
        reset()
        super.onResume()
    }


    override fun initUI() {
        super.initUI()

        initIdCardDetector()

        binding = FragmentIdScanTiltBinding.inflate(
            LayoutInflater.from(context),
            previewContainerBinding.get()?.root,
            true
        )

        binding.run {
            idScanTiltShootButton.setOnClickListener {
                ObjectAnimator.ofFloat(binding.idScanTiltShootAnimationImageview, "alpha", 1f, 0f)
                    .apply {
                        duration = 450
                        addListener(object : AnimatorListenerAdapter() {
                            override fun onAnimationEnd(animation: Animator) {
                                shoot()
                            }
                        })
                        start()
                    }
            }
        }

        timer = object : CountDownTimer(Configuration.autoCaptureTimeLimit, 3000) {

            override fun onTick(millisUntilFinished: Long) {
            }

            override fun onFinish() {
                alertCounts++
                shoot()
            }
        }

        cardDetectorState.set(CardDetectorState.START)
    }


    override fun analyze(image: ClovaVisionImage) {
        super.analyze(image)
        context?.let { context ->
            binding.run {
                if (idScanTiltMaskImageview.width <= 0 || idScanTiltMaskImageview.height <= 0) return
                runOnUiThread {
                    setCameraExposure(
                        PointF(
                            idScanTiltMaskImageview.x + idScanTiltMaskImageview.width / 2,
                            idScanTiltMaskImageview.y + idScanTiltMaskImageview.height / 2
                        )
                    )
                }

                if (cardDetectorState.get() == CardDetectorState.START) {
                    val maskImage =
                        image.crop(parent = layout, mask = idScanTiltMaskImageview, extraSize = 15)
                    idCardResult = idCardDetector.detectIdCard(maskImage)
                    idCardShotResult =
                        if (cardCaptureMode == CardCaptureMode.AUTO_CAPTURE) {
                            idCardDetector.shotIdCard(
                                Configuration.cardAccumulateCount
                            )
                        } else idCardDetector.shotIdCard(1)

                    if (idCardShotResult?.status != ClovaIdCardShotStatus.NOT_AVAILABLE &&
                        cardCaptureMode == CardCaptureMode.AUTO_CAPTURE) {
                        shoot()
                    }

                    updateUI(context)
                }
            }
        }
    }

    private fun reset() {
        alertCounts = 0
        cardCaptureMode = CardCaptureMode.AUTO_CAPTURE

        timer?.let {
            it.cancel()
            it.start()
        }

        bottomSheetDialog?.dismiss()

        cardDetectorState.set(CardDetectorState.START)
    }

    private fun shoot() {
        context?.let { context ->
            cardDetectorState.set(CardDetectorState.DETECTED)
            val bottomSheetView =
                layoutInflater.inflate(R.layout.layout_bottom_sheet_card, null, true)
            val isHideable: Boolean

            timer?.cancel()

            var similarity = 0f
            idCardShotResult?.idCard?.faceInfo?.faceImage?.let {
                val cardFrontFace = Configuration.cardScanFrontFace
                val cardTiltFace = faceDetector.detectFace(it).faces.firstOrNull()
                if (cardFrontFace != null && cardTiltFace != null) {
                    similarity = ClovaFaceDetector.getSimilarity(cardFrontFace, cardTiltFace)
                }
            }

            val similarityFailed = (similarity < Configuration.edgeSimilarityThreshold)
            if (idCardShotResult?.status == ClovaIdCardShotStatus.AVAILABLE && !similarityFailed) {
                Configuration.cardScanTiltResult = idCardShotResult?.idCard
                runOnUiThread {
                    activity?.findNavController(R.id.nav_host_fragment)
                        ?.navigate(R.id.idCardTiltResultFragment)
                }
                return
            } else if (alertCounts < 1 || cardCaptureMode == CardCaptureMode.MANUAL_CAPTURE) {
                if (idCardShotResult == null || idCardShotResult?.status == ClovaIdCardShotStatus.NOT_AVAILABLE) {
                    bottomSheetView.findViewById<ImageView>(R.id.bottom_sheet_icon_imageview).background =
                        resources.getDrawable(R.drawable.icon_bottom_sheet_caution, null)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_head_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_fail_head)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_body_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_fail_body)
                } else if (similarityFailed) {
                    bottomSheetView.findViewById<ImageView>(R.id.bottom_sheet_icon_imageview).background =
                        resources.getDrawable(R.drawable.icon_bottom_sheet_caution, null)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_head_textview).text =
                        resources.getString(R.string.id_scan_alert_face_fail_head)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_body_textview).text =
                        resources.getString(R.string.id_scan_alert_face_fail_body)
                } else if (idCardShotResult?.status == ClovaIdCardShotStatus.GLARE_ERROR) {
                    bottomSheetView.findViewById<ImageView>(R.id.bottom_sheet_icon_imageview).background =
                        resources.getDrawable(R.drawable.icon_bottom_sheet_caution, null)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_head_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_glare_head)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_body_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_glare_body)
                } else if (idCardShotResult?.status == ClovaIdCardShotStatus.DARK_ERROR) {
                    bottomSheetView.findViewById<ImageView>(R.id.bottom_sheet_icon_imageview).background =
                        resources.getDrawable(R.drawable.icon_bottom_sheet_caution, null)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_head_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_dark_head)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_body_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_dark_body)
                } else {
                    bottomSheetView.findViewById<ImageView>(R.id.bottom_sheet_icon_imageview).background =
                        resources.getDrawable(R.drawable.icon_bottom_sheet_caution, null)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_head_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_blur_head)
                    bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_body_textview).text =
                        resources.getString(R.string.id_scan_alert_detect_blur_body)
                }
                bottomSheetView.findViewById<Button>(R.id.bottom_sheet_retry_button).text =
                    resources.getString(R.string.id_scan_alert_button_retry)

                alertCounts++
                isHideable = true
            } else {
                cardCaptureMode = CardCaptureMode.MANUAL_CAPTURE

                bottomSheetView.findViewById<ImageView>(R.id.bottom_sheet_icon_imageview).background =
                    resources.getDrawable(R.drawable.icon_bottom_sheet_camera, null)
                bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_head_textview).text =
                    resources.getString(R.string.id_scan_alert_change_manual_capture_head)
                bottomSheetView.findViewById<TextView>(R.id.bottom_sheet_body_textview).text =
                    resources.getString(R.string.id_scan_alert_change_manual_capture_body)
                bottomSheetView.findViewById<Button>(R.id.bottom_sheet_retry_button).text =
                    resources.getString(R.string.id_scan_alert_button_change_manual)
                isHideable = false
            }

            runOnUiThread {
                bottomSheetDialog = BottomSheetDialog(context)

                bottomSheetView.findViewById<Button>(R.id.bottom_sheet_retry_button)
                    .setOnClickListener {
                        bottomSheetDialog?.dismiss()
                    }

                bottomSheetDialog?.setOnDismissListener {
                    cardDetectorState.set(CardDetectorState.START)
                    idCardDetector.reset()
                    if (cardCaptureMode != CardCaptureMode.MANUAL_CAPTURE) {
                        timer?.start()
                    }
                }

                if (isHideable) {
                    bottomSheetDialog?.setCancelable(true)
                    bottomSheetDialog?.setCanceledOnTouchOutside(true)
                } else {
                    bottomSheetDialog?.setCancelable(false)
                    bottomSheetDialog?.setCanceledOnTouchOutside(false)
                }

                bottomSheetDialog?.setContentView(bottomSheetView)
                bottomSheetDialog?.show()
            }
        }
    }


    private fun updateUI(context: Context) {
        runOnUiThread {
            binding.run {
                when (cardCaptureMode) {
                    CardCaptureMode.MANUAL_CAPTURE -> {
                        idScanTiltShootButton.isVisible = true
                    }

                    else -> {
                        idScanTiltShootButton.isVisible = false
                    }
                }

                val container = Bitmap.createBitmap(
                    layout.width,
                    layout.height,
                    Bitmap.Config.ARGB_8888
                )

                val canvas = Canvas(container)
                canvas.drawBackgroundDimLayer(
                    context,
                    layout,
                    idScanTiltMaskImageview,
                    colorId = R.color.black_10,
                    targetAngle = 105
                )

                if (idCardResult?.rectInfo != null) {
                    canvas.drawCardBorderLines(
                        context,
                        idScanTiltMaskImageview,
                        R.color.ClovaGreen,
                        targetAngle = 105
                    )
                } else {
                    canvas.drawCardCornerIcon(context, idScanTiltMaskImageview, targetAngle = 105)
                }
                idScanTiltDimlayer.setImageBitmap(container)
            }
        }
    }


    private fun initIdCardDetector() {
        faceDetector = ClovaFaceDetector(
            ClovaFaceDetectorOption(
                stageTypes = ClovaFaceDetectorOption.StageTypes(
                    detector = ClovaFaceDetectorOption.Stage(
                        isEnabled = true,
                        context = requireContext(),
                        modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesDetector.value
                    ),
                    landmarker = ClovaFaceDetectorOption.Stage(
                        isEnabled = true,
                        context = requireContext(),
                        modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesLandmarker.value
                    ),
                    aligner = ClovaFaceDetectorOption.Stage(
                        isEnabled = true
                    ),
                    recognizer = ClovaFaceDetectorOption.Stage(
                        isEnabled = true,
                        context = requireContext(),
                        modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesRecognizer.value
                    )
                )
            )
        )

        idCardDetector = ClovaIdCardDetector(
            ClovaFaceDetectorOption(
                stageTypes = ClovaFaceDetectorOption.StageTypes(
                    detector = ClovaFaceDetectorOption.Stage(
                        isEnabled = true,
                        context = requireContext(),
                        modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesDetector.value
                    )
                )
            )
        )

        idCardDetector.setOption(
            ClovaIdCardDetectorOption(
                faceLocation = Configuration.ekycFaceLocation,
                targetAngle = 105,
                angleOffset = 7,
                checkCameraShaky = true,
                checkImageBlurry = true,
                checkImageDark = true,
                checkGlareDetected = true
            )
        )
    }


    enum class CardCaptureMode {
        AUTO_CAPTURE,
        MANUAL_CAPTURE
    }

    enum class CardDetectorState {
        START,
        DETECTED
    }
}
