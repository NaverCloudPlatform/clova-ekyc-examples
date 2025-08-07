/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.camera

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import ai.clova.eyed.example.databinding.FragmentProxyCameraBinding
import ai.clova.eyed.image.ClovaVisionImage
import java.util.concurrent.atomic.AtomicReference

open class ProxyCameraFragment : CameraXFragment() {

    var previewContainerBinding = AtomicReference<FragmentProxyCameraBinding>()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        previewContainerBinding.set(FragmentProxyCameraBinding.inflate(inflater, container, false))
        return previewContainerBinding.get()?.root
    }

    override fun analyze(image: ClovaVisionImage) {
        previewContainerBinding.get()?.viewPreview?.keepProxy(image.getBitmap())
    }

    override fun bindCameraUseCases() {
        bindCameraPreview()
    }
}