/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.camera

import ai.clova.eyed.example.utils.*
import android.os.Bundle
import android.util.Size
import android.view.View
import androidx.camera.core.Camera
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import ai.clova.eyed.image.ClovaVisionImage
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

abstract class CameraXFragment : Fragment() {

    private var cameraProvider: ProcessCameraProvider? = null
    open var lensFacing: Int = CameraSelector.LENS_FACING_BACK

    open lateinit var cameraExecutor: ExecutorService

    open lateinit var camera: Camera

    open val resolution: Size? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        debug(tag = TAG, message = "onViewCreated")
        super.onViewCreated(view, savedInstanceState)

        cameraExecutor = Executors.newSingleThreadExecutor()
        setupCamera()
        initUI()
    }

    open fun initUI() { /* Do nothing */
    }

    open fun analyze(image: ClovaVisionImage) { /* Do nothing */
    }

    private fun setupCamera() {
        context?.let { context ->
            val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
            cameraProviderFuture.addListener({
                cameraProvider = cameraProviderFuture.get()
                bindCameraUseCases()
            }, ContextCompat.getMainExecutor(context))
        }
    }

    open fun checkCameraInitialize(): Boolean {
        return ::camera.isInitialized
    }

    open fun bindCameraUseCases() { /* Do nothing */
    }

    fun bindCameraPreview(preview: Preview? = null) {
        val cameraProvider = cameraProvider
            ?: throw IllegalStateException("Camera initialization failed.")

        val cameraSelector = CameraSelector.Builder().requireLensFacing(lensFacing).build()
        val imageAnalyzer = ImageAnalysis.Builder()
            .apply {
                resolution?.also { res -> setTargetResolution(res) }
            }
            .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_RGBA_8888)
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()
            .also {
                val imageAnalyzer = VisionImageAnalyzer { value ->
                    analyze(value)
                }

                imageAnalyzer.isMirroredImage = (lensFacing == CameraSelector.LENS_FACING_FRONT)
                it.setAnalyzer(cameraExecutor, imageAnalyzer)
            }

        cameraProvider.unbindAll()

        runCatching {
            camera = if (preview != null) {
                cameraProvider.bindToLifecycle(this, cameraSelector, imageAnalyzer, preview)
            } else {
                cameraProvider.bindToLifecycle(this, cameraSelector, imageAnalyzer)
            }

        }.onFailure {
            warn(tag = "warn", throwable = it)
        }
    }
}
