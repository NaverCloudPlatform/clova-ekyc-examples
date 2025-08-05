/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.utils

import android.graphics.ImageFormat
import android.media.Image
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import ai.clova.eyed.image.ClovaVisionImage
import androidx.camera.core.ExperimentalGetImage
import java.nio.ByteBuffer
import kotlin.math.min


typealias AnalyzerListener = (value: ClovaVisionImage) -> Unit

class VisionImageAnalyzer(listener: AnalyzerListener? = null) : ImageAnalysis.Analyzer {

    private val listeners = ArrayList<AnalyzerListener>().apply { listener?.let { add(it) } }
    var isMirroredImage: Boolean = false

    @ExperimentalGetImage
    override fun analyze(image: ImageProxy) {
        if (listeners.isEmpty()) {
            image.close()
            return
        }

        val visionImage: ClovaVisionImage? = when(image.planes.size){
            1 -> {
                val (rgbaBuffer) = image.planes.map { it.buffer }
                val rgbaSize = rgbaBuffer.remaining()

                val byteArray = ByteArray(size = rgbaSize).apply {
                    rgbaBuffer.get(this, 0, rgbaSize)
                }

                ClovaVisionImage(
                    byteArray,
                    image.width,
                    image.height,
                    ClovaVisionImage.ImageFormat.RGBA8888,
                    ClovaVisionImage.RotationDegrees.valueOf(image.imageInfo.rotationDegrees),
                    isMirroredImage
                )
            }
            3 -> {
                val nv21Buffer = imageToNV21ByteBuffer(image.width, image.height, image.image) ?: return
                nv21Buffer.rewind()
                val byteArray = nv21Buffer.array()

                ClovaVisionImage(
                    byteArray,
                    image.width,
                    image.height,
                    ClovaVisionImage.ImageFormat.NV21,
                    ClovaVisionImage.RotationDegrees.valueOf(image.imageInfo.rotationDegrees),
                    isMirroredImage
                )
            }
            else -> null
        }
        image.close()

        listeners.forEach {
            visionImage?.let {image ->
                it(image)
            }
        }
    }

    private fun imageToNV21ByteBuffer(w: Int, h: Int, image: Image?): ByteBuffer? {
        image ?: return null
        val format = image.format
        if (format != ImageFormat.YUV_420_888) {
            return null
        }
        val yRowStride = image.planes[0].rowStride

        var uvW = w / 2
        if (w and 1 == 1) {
            uvW++
        }
        var uvH = h / 2
        if (w and 1 == 1) {
            uvH++
        }
        val uvRowStride = image.planes[1].rowStride
        val uvPixelStride = image.planes[1].pixelStride

        val arr = ByteArray(w * h + uvW * uvH * 2)

        val yBuffer = image.planes[0].buffer
        val uBuffer = image.planes[1].buffer
        val vBuffer = image.planes[2].buffer

        // Y plane
        for (y in 0 until h) {
            yBuffer.position(y * yRowStride)
            yBuffer.get(arr, y * w, w)
        }

        // UV plane
        var pos = 0
        val basePos = w * h
        val uvRowPixels = uvW * uvPixelStride
        val uRowArr = ByteArray(uvRowPixels)
        val vRowArr = ByteArray(uvRowPixels)
        for (y in 0 until uvH) {
            uBuffer.position(y * uvRowStride)
            uBuffer.get(uRowArr, 0, min(uvRowPixels, uBuffer.remaining()))
            vBuffer.position(y * uvRowStride)
            vBuffer.get(vRowArr, 0, min(uvRowPixels, vBuffer.remaining()))
            for (x in 0 until uvW) {
                pos = basePos + (y * uvW + x) * 2
                arr[pos] = vRowArr[x * uvPixelStride]
                arr[pos + 1] = uRowArr[x * uvPixelStride]
            }
        }

        return ByteBuffer.wrap(arr)
    }
}