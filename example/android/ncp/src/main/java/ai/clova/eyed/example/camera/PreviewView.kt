/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.camera

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Matrix
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View

class PreviewView constructor(context: Context?, attributeSet: AttributeSet?) :
    View(context, attributeSet) {

    var drawer: PreviewDrawer? = null
    private var frame: Bitmap? = null

    fun keepProxy(frame: Bitmap) {
        this.frame = frame
        postInvalidate()
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        frame?.let { frame ->
            drawer?.draw(frame)
            val scaleRatio = height.toFloat() / frame.height
            val diff = (width.toFloat() - frame.width * scaleRatio) / 2
            val matrix = Matrix().also {
                it.postScale(scaleRatio, scaleRatio, 0f, 0f)
                it.postTranslate(diff, 0f)
            }
            canvas.drawBitmap(frame, matrix, Paint())
        }
    }
}