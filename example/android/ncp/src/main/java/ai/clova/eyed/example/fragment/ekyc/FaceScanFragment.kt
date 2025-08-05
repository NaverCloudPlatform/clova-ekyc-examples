/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc

import ai.clova.eyed.example.Configuration
import ai.clova.eyed.example.R
import ai.clova.eyed.example.camera.DefaultCameraFragment
import ai.clova.eyed.example.databinding.FragmentFaceScanBinding
import ai.clova.eyed.example.result.FaceScanResult
import ai.clova.eyed.example.utils.TAG
import ai.clova.eyed.example.utils.debug
import ai.clova.eyed.example.utils.drawBackgroundDimLayer
import ai.clova.eyed.example.utils.drawCardBorderLines
import ai.clova.eyed.example.utils.drawCardCornerIcon
import ai.clova.eyed.example.utils.runOnUiThread
import ai.clova.eyed.face.ncp.ClovaFaceDetector
import ai.clova.eyed.face.ClovaFaceDetectorOption
import ai.clova.eyed.face.data.ClovaFace
import ai.clova.eyed.face.data.ClovaFaceOpenableState
import ai.clova.eyed.face.data.ClovaPose
import ai.clova.eyed.image.ClovaVisionImage
import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ObjectAnimator
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.CountDownTimer
import android.util.Size
import android.view.LayoutInflater
import androidx.camera.core.CameraSelector
import androidx.core.view.isVisible
import androidx.navigation.findNavController
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicReference

class FaceScanFragment : DefaultCameraFragment() {

    private lateinit var binding: FragmentFaceScanBinding

    private lateinit var faceDetector: ClovaFaceDetector

    private val faceDetectorState = AtomicReference<FaceDetectorState>(FaceDetectorState.START)

    override var lensFacing: Int = CameraSelector.LENS_FACING_FRONT

    override val resolution = Size(1080, 1920)

    private var faceScanImage: Bitmap? = null

    private var facePreviewImage: Bitmap? = null

    private val faceDetected = AtomicBoolean(false)

    private var detectedFace: ClovaFace? = null


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

        bindImageProcessor()

        binding = FragmentFaceScanBinding.inflate(
            LayoutInflater.from(context),
            previewContainerBinding.get()?.root,
            true
        )

        binding.run {
            faceScanShootButton.setOnClickListener {
                shoot()
            }
        }
        faceDetectorState.set(FaceDetectorState.START)
    }


    override fun analyze(image: ClovaVisionImage) {
        super.analyze(image)

        context?.let { context ->
            binding.run {
                if (faceScanMaskImageview.width <= 0 || faceScanMaskImageview.height <= 0) return

                if (faceDetectorState.get() != FaceDetectorState.DETECTED) {
                    val faceList = faceDetector.detectFace(image).faces.filter {
                        val scaledBoundingBoxMaskRect =
                            image.rect(layout, faceScanBoundingboxImageview, 60)
                        val scaledMaskRect = image.rect(layout, faceScanMaskImageview)

                        val boundingBoxArea = it.boundingBox.width() * it.boundingBox.height()
                        val maskArea = scaledMaskRect.width() * scaledMaskRect.height()

                        scaledBoundingBoxMaskRect.contains(it.boundingBox) &&
                                it.pose == ClovaPose.FRONT &&
                                !it.occlusions.mouthOccluded &&
                                !it.occlusions.noseOccluded &&
                                (!it.occlusions.rightEyeOccluded || !it.occlusions.leftEyeOccluded) &&
                                boundingBoxArea >= maskArea * 0.2
                    }
                    val face = faceList.sortedWith { a, b ->
                        when {
                            a.boundingBox.width() * a.boundingBox.height() < b.boundingBox.width() * b.boundingBox.height() -> 1
                            a.boundingBox.width() * a.boundingBox.height() > b.boundingBox.width() * b.boundingBox.height() -> -1
                            else -> 0
                        }
                    }.firstOrNull()
                    if (face != null) {
                        faceDetected.set(true)
                        faceScanImage = image.crop(layout, faceScanMaskImageview, 60).getBitmap()
                        facePreviewImage = image.crop(layout, layout).getBitmap()
                        detectedFace = face
                    } else {
                        faceDetected.set(false)
                    }
                    updateUI(context)
                }
            }
        }
    }

    private fun reset() {
        faceDetectorState.set(FaceDetectorState.START)
        faceDetected.set(false)
        facePreviewImage = null
        faceScanImage = null
        binding.faceScanPreviewLayer.isVisible = false
    }

    private fun shoot() {
        faceDetectorState.set(FaceDetectorState.SHOOT)
        disableShootButton()

        object : CountDownTimer(2900, 10) {
            override fun onTick(millisUntilFinished: Long) {
                binding.faceScanCountTextview.text =
                    ((millisUntilFinished / 1000) + 1).toString()
                if (!faceDetected.get()) {
                    cancel()
                    faceDetectorState.set(FaceDetectorState.START)
                    binding.faceScanCountTextview.text = ""
                }
            }

            override fun onFinish() {
                faceDetectorState.set(FaceDetectorState.DETECTED)
                binding.faceScanCountTextview.text = ""

                if (detectedFace?.leftEye?.state == ClovaFaceOpenableState.OPEN && detectedFace?.rightEye?.state == ClovaFaceOpenableState.OPEN) {
                    if (faceScanImage != null && detectedFace != null) {
                        Configuration.faceScanResult =
                            FaceScanResult(faceScanImage!!, detectedFace!!)
                    }
                    Configuration.facePreviewImage = facePreviewImage

                    ObjectAnimator.ofFloat(
                        binding.faceScanShootAnimationImageview,
                        "alpha",
                        1f,
                        0f
                    ).apply {
                        duration = 450
                        addListener(object : AnimatorListenerAdapter() {
                            override fun onAnimationEnd(animation: Animator) {
                                activity?.findNavController(R.id.nav_host_fragment)
                                    ?.navigate(R.id.faceScanResultFragment)
                            }
                        })
                        start()
                    }
                } else {
                    reset()
                }
            }
        }.start()
    }


    private fun updateUI(context: Context) {
        runOnUiThread {
            binding.run {
                if (faceDetectorState.get() != FaceDetectorState.SHOOT) {
                    if (faceDetected.get()) enableShootButton() else disableShootButton()
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
                    faceScanMaskImageview,
                    colorId = R.color.black_20
                )

                if (faceDetected.get()) {
                    canvas.drawCardBorderLines(
                        context,
                        faceScanMaskImageview,
                        R.color.ClovaGreen
                    )
                } else {
                    canvas.drawCardCornerIcon(context, faceScanMaskImageview)
                }
                faceScanDimlayer.setImageBitmap(container)
            }
        }
    }

    private fun enableShootButton() {
        binding.faceScanShootButton.isEnabled = true
        binding.faceScanShootButton.alpha = 1.0f
    }

    private fun disableShootButton() {
        binding.faceScanShootButton.isEnabled = false
        binding.faceScanShootButton.alpha = 0.5f
    }

    private fun bindImageProcessor() {
        context?.let { context ->
                faceDetector = ClovaFaceDetector(
                    option = ClovaFaceDetectorOption(
                        stageTypes = ClovaFaceDetectorOption.StageTypes(
                            detector = ClovaFaceDetectorOption.Stage(
                                isEnabled = true,
                                context = context,
                                modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesDetector.value
                            ),
                            landmarker = ClovaFaceDetectorOption.Stage(
                                isEnabled = true,
                                context = context,
                                modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesLandmarker.value
                            ),
                            aligner = ClovaFaceDetectorOption.Stage(
                                isEnabled = true
                            ),
                            recognizer = ClovaFaceDetectorOption.Stage(
                                isEnabled = true,
                                context = context,
                                modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesRecognizer.value
                            )
                        ),
                    ),
                )
            }
    }

    enum class FaceDetectorState {
        START,
        SHOOT,
        DETECTED
    }
}
