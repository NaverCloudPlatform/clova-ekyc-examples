/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.fragment.ekyc


import ai.clova.eyed.api.ncp.NcpEkycApiManager
import ai.clova.eyed.api.ncp.internal.core.compare
import ai.clova.eyed.example.Configuration
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Bundle
import android.util.Size
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import androidx.camera.core.CameraSelector
import androidx.core.view.isVisible
import androidx.navigation.findNavController
import ai.clova.eyed.example.R
import ai.clova.eyed.example.camera.DefaultCameraFragment
import ai.clova.eyed.example.databinding.FragmentFaceMotionBinding
import ai.clova.eyed.example.databinding.SettingsMotionBinding
import ai.clova.eyed.example.utils.runOnUiThread
import ai.clova.eyed.face.ncp.ClovaFaceDetector
import ai.clova.eyed.image.ClovaVisionImage
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicReference
import ai.clova.eyed.example.utils.*
import ai.clova.eyed.face.ClovaFaceDetectorOption
import android.app.Dialog
import android.widget.Button
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class FaceMotionFragment : DefaultCameraFragment() {

    private lateinit var binding: FragmentFaceMotionBinding

    private var setting: SettingsMotionBinding? = null

    private lateinit var faceDetector: ClovaFaceDetector

    override var lensFacing: Int = CameraSelector.LENS_FACING_FRONT

    override val resolution = Size(1080, 1920)

    private val motionDetectorState = AtomicReference(MotionDetectorState.START)

    private val faceDetected = AtomicBoolean(false)

    private var motionPreviewImage: Bitmap? = null

    private var selectedMotion =
        if (Configuration.isDebugMode) Configuration.selectedMotion else Configuration.ekycSelectedMotion

    private lateinit var dialog: Dialog

    private val apiManager = NcpEkycApiManager {
        faceInvokeUrl = Configuration.faceInvokeUrl
        faceSecretKey = Configuration.faceSecretKey
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        debug(tag = TAG, message = "onCreateView")

        dialog = Dialog(requireContext())
        if (Configuration.isDebugMode) {
            setHasOptionsMenu(true)
        } else {
            setHasOptionsMenu(false)
        }
        return super.onCreateView(inflater, container, savedInstanceState)
    }


    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        menu.clear()
        inflater.inflate(R.menu.setting_menu, menu)
        super.onCreateOptionsMenu(menu, inflater)
    }


    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == R.id.settingMenu) showSettingMenu()
        return super.onOptionsItemSelected(item)
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

        bindImageProcessor()

        binding = FragmentFaceMotionBinding.inflate(
            LayoutInflater.from(context),
            previewContainerBinding.get()?.root,
            true
        )

        initMotionUI()
        motionDetectorState.set(MotionDetectorState.START)
    }


    private fun initMotionUI() {
        when (selectedMotion) {
            Configuration.Motion.MOUTH_OPEN -> {
                binding.motionSpoofInfo.text =
                    resources.getString(R.string.face_motion_mouth)
                binding.motionAnimation.setAnimation("EyeD_motion_mouth.json")
            }

            Configuration.Motion.EYE_BLINK -> {
                binding.motionSpoofInfo.text =
                    resources.getString(R.string.face_motion_eye)
                binding.motionAnimation.setAnimation("EyeD_motion_eye_blink.json")
            }

            Configuration.Motion.HEAD_ROLL -> {
                binding.motionSpoofInfo.text =
                    resources.getString(R.string.face_motion_roll)
                binding.motionAnimation.setAnimation("EyeD_motion_roll.json")
            }

            Configuration.Motion.HEAD_NOD -> {
                binding.motionSpoofInfo.text =
                    resources.getString(R.string.face_motion_nod)
                binding.motionAnimation.setAnimation("EyeD_motion_nod.json")
            }

            Configuration.Motion.HEAD_SHAKE -> {
                binding.motionSpoofInfo.text =
                    resources.getString(R.string.face_motion_shake)
                binding.motionAnimation.setAnimation("EyeD_motion_shake.json")
            }
        }

        binding.motionAnimation.resumeAnimation()
        binding.motionAnimation.isVisible = true
        binding.motionSpoofInfo.isVisible = true
    }


    override fun analyze(image: ClovaVisionImage) {
        super.analyze(image)

        context?.let { context ->
            binding.run {
                if (motionSpoofMaskImageview.width <= 0 || motionSpoofMaskImageview.height <= 0) return

                if (motionDetectorState.get() == MotionDetectorState.START) {
                    val faceList = faceDetector.detectFace(image).faces.filter {
                        val scaledBoundingBoxMaskRect =
                            image.rect(layout, motionSpoofBoundingBoxImageview, 60)
                        val scaledMaskRect = image.rect(layout, motionSpoofMaskImageview)

                        val boundingBoxArea = it.boundingBox.width() * it.boundingBox.height()
                        val maskArea = scaledMaskRect.width() * scaledMaskRect.height()

                        var similarity = 1f
                        val frontFace = Configuration.faceScanResult?.face
                        frontFace?.let { frontFace ->
                            similarity = ClovaFaceDetector.getSimilarity(frontFace, it)
                        }

                        scaledBoundingBoxMaskRect.contains(it.boundingBox) &&
                                !it.occlusions.noseOccluded &&
                                boundingBoxArea >= maskArea * 0.2 &&
                                similarity >= Configuration.edgeSimilarityThreshold
                    }

                    val face = faceList.sortedWith { a, b ->
                        when {
                            a.boundingBox.width() * a.boundingBox.height() < b.boundingBox.width() * b.boundingBox.height() -> 1
                            a.boundingBox.width() * a.boundingBox.height() > b.boundingBox.width() * b.boundingBox.height() -> -1
                            else -> 0
                        }
                    }.firstOrNull()

                    face?.let {
                        faceDetected.set(true)
                        when (selectedMotion) {
                            Configuration.Motion.EYE_BLINK -> {
                                if (face.motions.eyeBlink) {
                                    motionPreviewImage =
                                        image.crop(layout, layout).getBitmap()
                                    shoot()
                                }
                            }

                            Configuration.Motion.MOUTH_OPEN -> {
                                if (face.motions.mouthOpen) {
                                    motionPreviewImage =
                                        image.crop(layout, layout).getBitmap()
                                    shoot()
                                }
                            }

                            Configuration.Motion.HEAD_NOD -> {
                                if (face.motions.headNod) {
                                    motionPreviewImage =
                                        image.crop(layout, layout).getBitmap()
                                    shoot()
                                }
                            }

                            Configuration.Motion.HEAD_ROLL -> {
                                if (face.motions.headRoll) {
                                    motionPreviewImage =
                                        image.crop(layout, layout).getBitmap()
                                    shoot()
                                }
                            }

                            Configuration.Motion.HEAD_SHAKE -> {
                                if (face.motions.headShake) {
                                    motionPreviewImage =
                                        image.crop(layout, layout).getBitmap()
                                    shoot()
                                }
                            }
                        }
                    } ?: run {
                        faceDetected.set(false)
                    }
                    updateUI(context)
                } else if (motionDetectorState.get() == MotionDetectorState.DETECTED) {
                    if (Configuration.isDebugMode) {
                        Configuration.facePreviewImage = motionPreviewImage
                        Configuration.compareResult = null
                        runOnUiThread {
                            activity?.findNavController(R.id.nav_host_fragment)
                                ?.navigate(R.id.faceMotionResultFragment)
                        }
                    } else {
                        motionDetectorState.set(MotionDetectorState.WAIT_RESPONSE)
                        runOnUiThread {
                            motionLoadingLayer.isVisible = true
                            motionLoadingAnimation.apply {
                                isVisible = true
                                playAnimation()
                            }
                        }

                        Configuration.faceScanResult?.let { faceResult ->
                            Configuration.cardScanFrontResult?.let { cardResult ->
                                GlobalScope.launch(Dispatchers.IO) {
                                    val compareResult = apiManager.compare(
                                        face1 = cardResult.originImage.getBitmap(),
                                        face2 = faceResult.faceImage
                                    )
                                    Configuration.compareResult = compareResult

                                    runOnUiThread {
                                        if (Configuration.compareResult?.apiError?.code.equals("0022")) {
                                            motionLoadingAnimation.isVisible = false
                                            showDialog()
                                        } else {
                                            activity?.findNavController(R.id.nav_host_fragment)
                                                ?.navigate(R.id.faceMotionResultFragment)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    private fun reset() {
        motionDetectorState.set(MotionDetectorState.START)
        faceDetected.set(false)
        motionPreviewImage = null

        binding.motionPreviewLayer.isVisible = false
        binding.motionLoadingLayer.isVisible = false

        initMotionUI()
    }


    private fun shoot() {
        motionDetectorState.set(MotionDetectorState.DETECTED)

        runOnUiThread {
            binding.motionSpoofSuccessImageview.isVisible = true
            binding.motionPreviewLayer.isVisible = true
            binding.motionPreviewLayer.setImageBitmap(motionPreviewImage)
        }
    }


    private fun updateUI(context: Context) {
        runOnUiThread {
            binding.run {
                val container = Bitmap.createBitmap(
                    layout.width,
                    layout.height,
                    Bitmap.Config.ARGB_8888
                )

                val canvas = Canvas(container)
                canvas.drawBackgroundDimLayer(
                    context,
                    layout,
                    motionSpoofMaskImageview,
                    colorId = R.color.black_20
                )

                if (faceDetected.get()) {
                    canvas.drawCardBorderLines(
                        context,
                        motionSpoofMaskImageview,
                        R.color.ClovaGreen
                    )
                } else {
                    canvas.drawCardCornerIcon(context, motionSpoofMaskImageview)
                }
                motionSpoofDimlayer.setImageBitmap(container)
            }
        }
    }


    private fun bindImageProcessor() {
        context?.let {
            faceDetector = ClovaFaceDetector(
                option = ClovaFaceDetectorOption(
                    stageTypes = ClovaFaceDetectorOption.StageTypes(
                        detector = ClovaFaceDetectorOption.Stage(
                            isEnabled = true,
                            context = it,
                            modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesDetector.value
                        ),
                        landmarker = ClovaFaceDetectorOption.Stage(
                            isEnabled = true,
                            context = it,
                            modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesLandmarker.value
                        ),
                        aligner = ClovaFaceDetectorOption.Stage(
                            isEnabled = true
                        ),
                        recognizer = ClovaFaceDetectorOption.Stage(
                            isEnabled = true,
                            context = it,
                            modelFilePathFromAsset = Configuration.ClovaeyesModel.ClovaEyesRecognizer.value
                        )
                    ),
                ),
            )
        }
    }


    private fun showSettingMenu() {
        setting?.run {
            layout.visibility = View.GONE
            setting = null
            initMotionUI()
            return
        }

        context?.let { context ->
            setting = SettingsMotionBinding.inflate(
                LayoutInflater.from(context),
                binding.layout,
                true
            )
        }

        setting?.run {
            when (selectedMotion) {
                Configuration.Motion.MOUTH_OPEN -> motionSettingsMouthOpen.isChecked = true
                Configuration.Motion.EYE_BLINK -> motionSettingsEyeBlink.isChecked = true
                Configuration.Motion.HEAD_NOD -> motionSettingsHeadNod.isChecked = true
                Configuration.Motion.HEAD_ROLL -> motionSettingsHeadRoll.isChecked = true
                Configuration.Motion.HEAD_SHAKE -> motionSettingsHeadShake.isChecked = true

            }

            arrayOf(
                motionSettingsEyeBlink,
                motionSettingsMouthOpen,
                motionSettingsHeadNod,
                motionSettingsHeadRoll,
                motionSettingsHeadShake
            ).forEach { it ->
                it.setOnClickListener {
                    when (it) {
                        motionSettingsEyeBlink -> {
                            Configuration.selectedMotion = Configuration.Motion.EYE_BLINK
                            selectedMotion = Configuration.selectedMotion
                            it.isSelected = true
                        }

                        motionSettingsMouthOpen -> {
                            Configuration.selectedMotion = Configuration.Motion.MOUTH_OPEN
                            selectedMotion = Configuration.selectedMotion
                            it.isSelected = true
                        }

                        motionSettingsHeadNod -> {
                            Configuration.selectedMotion = Configuration.Motion.HEAD_NOD
                            selectedMotion = Configuration.selectedMotion
                            it.isSelected = true
                        }

                        motionSettingsHeadRoll -> {
                            Configuration.selectedMotion = Configuration.Motion.HEAD_ROLL
                            selectedMotion = Configuration.selectedMotion
                            it.isSelected = true
                        }

                        motionSettingsHeadShake -> {
                            Configuration.selectedMotion = Configuration.Motion.HEAD_SHAKE
                            selectedMotion = Configuration.selectedMotion
                            it.isSelected = true
                        }
                    }
                }
            }

            outSpace.setOnClickListener {
                this.layout.visibility = View.GONE
                setting = null
                initMotionUI()
            }
        }
    }

    private fun showDialog() {
        dialog.setContentView(R.layout.layout_invalid_domain_alert)
        dialog.setCanceledOnTouchOutside(false)
        dialog.setCancelable(false)

        dialog.findViewById<Button>(R.id.button_confirm).setOnClickListener {
            activity?.findNavController(R.id.nav_host_fragment)
                ?.popBackStack(R.id.documentLicenseFragment, false)
            dialog.dismiss()
        }
        dialog.show()
    }


    enum class MotionDetectorState {
        START,
        DETECTED,
        WAIT_RESPONSE
    }
}
