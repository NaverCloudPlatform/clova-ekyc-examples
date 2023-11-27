/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.camera

import android.graphics.PointF
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.camera.core.FocusMeteringAction
import androidx.camera.core.Preview
import ai.clova.eyed.example.databinding.FragmentDefaultCameraBinding
import java.util.concurrent.atomic.AtomicReference

open class DefaultCameraFragment : CameraXFragment() {

    var previewContainerBinding = AtomicReference<FragmentDefaultCameraBinding>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        previewContainerBinding.set(
            FragmentDefaultCameraBinding.inflate(
                inflater,
                container,
                false
            )
        )
        return previewContainerBinding.get()?.root
    }

    protected fun setCameraExposure(point:PointF) {
        val factory = previewContainerBinding.get().viewPreview.meteringPointFactory
        val point = factory.createPoint(point.x, point.y)
        val action = FocusMeteringAction.Builder(point, FocusMeteringAction.FLAG_AE)
            .disableAutoCancel()
            .build()

        if(checkCameraInitialize()) {
            camera.cameraControl.startFocusAndMetering(action)
        }
    }

    override fun bindCameraUseCases() {
        val preview = Preview.Builder()
            .apply {
                resolution?.also { res -> setTargetResolution(res) }
            }.build().also {
                it.setSurfaceProvider(previewContainerBinding.get()?.viewPreview?.surfaceProvider)
            }

        bindCameraPreview(preview)
    }
}