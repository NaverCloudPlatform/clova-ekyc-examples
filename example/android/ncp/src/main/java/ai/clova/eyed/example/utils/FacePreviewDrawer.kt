/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.Rect
import androidx.core.content.ContextCompat
import ai.clova.eyed.example.R
import ai.clova.eyed.example.camera.PreviewDrawer
import ai.clova.eyed.face.data.ClovaFace

class FacePreviewDrawer(
    private val context: Context,
    private val drawBoundingBox: Boolean,
    private val drawTrackingId: Boolean = drawBoundingBox,
    private val drawLandmark: Boolean
) : PreviewDrawer() {

    var faceResult: List<ClovaFace>? = null
    var focusedTrackingId: Int? = null

    private val landmarkPaint = Paint().apply {
        color = ContextCompat.getColor(context, R.color.ClovaGreen)
        isAntiAlias = true
    }

    override fun draw(frame: Bitmap, scale: Float) {
        val resultCanvas = Canvas(frame)
        val faceResultSize = faceResult?.size ?: 0

        faceResult?.forEach {
            if (drawTrackingId && faceResultSize > 1) {
                drawTrackingId(resultCanvas, scale, it)
            }

            if (drawBoundingBox) {
                drawBoundingBox(resultCanvas, scale, it)
            }

            if (drawLandmark) {
                drawLandmark(resultCanvas, scale, it)
            }
        }
    }

    /** 인식된 얼굴 번호 */
    private fun drawTrackingId(
        canvas: Canvas,
        scale: Float,
        face: ClovaFace
    ) {
        val textPaint = Paint().apply {
            color = ContextCompat.getColor(context, R.color.ClovaGreen)
            textSize = 15f * scale
            isAntiAlias = true
        }

        canvas.drawText(
            face.trackingId.toString(),
            face.boundingBox.left.toFloat(),
            face.boundingBox.top.toFloat() - (textPaint.textSize / 2),
            textPaint
        )
    }


    /** 얼굴로 인식한 테두리를 렌더링 */
    private fun drawBoundingBox(
        canvas: Canvas,
        scale: Float,
        face: ClovaFace
    ) {
        val paint = Paint().apply {
            color = ContextCompat.getColor(context, R.color.ClovaGreen)
            style = Paint.Style.STROKE
            isAntiAlias = true
            strokeWidth = if (faceResult?.size != 1) {
                if (face.trackingId == focusedTrackingId) 3f * scale
                else 1f * scale
            } else {
                if (face.boundingBox.width() in 1..49) 2f
                else 2f * scale
            }
        }

        val paintingRect = Rect(
            (face.boundingBox.left - paint.strokeWidth / 2).toInt() - 1,
            (face.boundingBox.top - paint.strokeWidth / 2).toInt() - 1,
            (face.boundingBox.right + paint.strokeWidth / 2).toInt() + 1,
            (face.boundingBox.bottom + paint.strokeWidth / 2).toInt() + 1
        )

        canvas.drawRect(paintingRect, paint)
    }


    /** Contour 랜드마크 렌더링 */
    private fun drawLandmark(
        canvas: Canvas,
        scale: Float,
        face: ClovaFace
    ) {
        val contour = face.contours
        val radius = when {
            face.boundingBox.width() in 1..49 -> 1f
            face.boundingBox.width() in 50..99 -> 1.5f * scale
            else -> 2f * scale
        }

        contour.forEach {
            canvas.drawCircle(it.x, it.y, radius, landmarkPaint)
        }
    }
}