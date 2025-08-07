/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
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
import ai.clova.eyed.example.databinding.FragmentIdScanFrontBinding
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.drawBackgroundDimLayer
import ai.clova.eyed.example.utils.drawCardBorderLines
import ai.clova.eyed.example.utils.drawCardCornerIcon
import ai.clova.eyed.example.utils.runOnUiThread
import ai.clova.eyed.face.ClovaFaceDetectorOption
import ai.clova.eyed.face.ncp.ClovaFaceDetector
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

class IdCardScanFrontFragment : DefaultCameraFragment() {

    private lateinit var binding: FragmentIdScanFrontBinding

    override val resolution = Size(1080, 1920)

    private lateinit var idCardDetector: ClovaIdCardDetector
    private lateinit var faceDetector: ClovaFaceDetector

    private val cardDetectorState = AtomicReference(CardDetectorState.START)
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
        binding = FragmentIdScanFrontBinding.inflate(
            LayoutInflater.from(context),
            previewContainerBinding.get()?.root,
            true
        )

        binding.run {
            idScanFrontShootButton.setOnClickListener {
                ObjectAnimator.ofFloat(binding.idScanFrontShootAnimationImageview, "alpha", 1f, 0f)
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
                if (idScanFrontMaskImageview.width <= 0 || idScanFrontMaskImageview.height <= 0) return
                runOnUiThread {
                    setCameraExposure(
                        PointF(
                            idScanFrontMaskImageview.x + idScanFrontMaskImageview.width / 2,
                            idScanFrontMaskImageview.y + idScanFrontMaskImageview.height / 2
                        )
                    )
                }

                if (cardDetectorState.get() == CardDetectorState.START) {
                    val maskImage =
                        image.crop(parent = layout, mask = idScanFrontMaskImageview, extraSize = 15)
                    idCardResult = idCardDetector.detectIdCard(maskImage)
                    idCardShotResult =
                        if (cardCaptureMode == CardCaptureMode.AUTO_CAPTURE) idCardDetector.shotIdCard(
                            Configuration.cardAccumulateCount
                        ) else idCardDetector.shotIdCard(1)

                    if (idCardShotResult?.status != ClovaIdCardShotStatus.NOT_AVAILABLE && cardCaptureMode == CardCaptureMode.AUTO_CAPTURE) {
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

        Configuration.documentResult = null

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

            if (idCardShotResult?.status == ClovaIdCardShotStatus.AVAILABLE) {
                Configuration.cardScanFrontResult = idCardShotResult?.idCard
                if (Configuration.scenarioMode != Configuration.ScenarioMode.COMPARE) {
                    Configuration.cardScanFrontResult?.faceInfo?.faceImage?.let { visionImage ->
                        val cardFace = faceDetector.detectFace(visionImage).faces.firstOrNull()
                        cardFace?.let {
                            Configuration.cardScanFrontFace = it
                            runOnUiThread {
                                activity?.findNavController(R.id.nav_host_fragment)
                                    ?.navigate(R.id.idCardFrontResultFragment)
                            }
                        }
                    }
                } else {
                    runOnUiThread {
                        activity?.findNavController(R.id.nav_host_fragment)
                            ?.navigate(R.id.faceScanFragment)
                    }
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
                        idScanFrontShootButton.isVisible = true
                    }

                    else -> {
                        idScanFrontShootButton.isVisible = false
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
                    idScanFrontMaskImageview,
                    colorId = R.color.black_10
                )

                if (idCardResult?.rectInfo != null) {
                    canvas.drawCardBorderLines(
                        context,
                        idScanFrontMaskImageview,
                        R.color.ClovaGreen
                    )
                } else {
                    canvas.drawCardCornerIcon(context, idScanFrontMaskImageview)
                }
                idScanFrontDimlayer.setImageBitmap(container)
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
