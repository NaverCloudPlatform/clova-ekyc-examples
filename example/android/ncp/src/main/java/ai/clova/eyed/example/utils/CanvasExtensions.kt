/**
 * Copyright 2021-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.utils

import android.content.Context
import android.graphics.*
import android.util.TypedValue
import android.view.View
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.toBitmap
import ai.clova.eyed.example.R

fun Canvas.drawBackgroundDimLayer(
    context: Context,
    frame: View,
    maskArea: View,
    colorId: Int = R.color.black_60,
    targetAngle: Int = 90
) {
    val outRect = Rect(frame.left, frame.top, frame.right, frame.bottom)
    val innerRect =
        Rect(maskArea.left, maskArea.top, maskArea.right, maskArea.bottom)

    val paint = Paint(Paint.ANTI_ALIAS_FLAG)

    // draw dimLayer
    paint.color = ContextCompat.getColor(context, colorId)
    this.drawRect(outRect, paint)

    val tl = PointF(innerRect.left.toFloat(), innerRect.top.toFloat())
    val tr = PointF(innerRect.right.toFloat(), innerRect.top.toFloat())
    val bl = PointF(innerRect.left.toFloat(), innerRect.bottom.toFloat())
    val br = PointF(innerRect.right.toFloat(), innerRect.bottom.toFloat())

    val diff = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        (90 - targetAngle) * (2.6).toFloat(),
        context.resources.displayMetrics
    )

    val path = Path()
    if (diff >= 0) {
        path.moveTo(tl.x, tl.y)
        path.lineTo(tl.x, tl.y)
        path.lineTo(tr.x, tr.y)
        path.lineTo(br.x - diff, br.y)
        path.lineTo(bl.x + diff, br.y)
        path.close()
    } else {
        path.moveTo(bl.x, bl.y)
        path.lineTo(bl.x, bl.y)
        path.lineTo(br.x, br.y)
        path.lineTo(tr.x + diff, tr.y)
        path.lineTo(tl.x - diff, tl.y)
        path.close()
    }

    // draw cardArea
    paint.color = ContextCompat.getColor(context, android.R.color.transparent)
    paint.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_OUT)
    this.drawPath(path, paint)
}

fun Canvas.drawCardCornerIcon(
    context: Context,
    rect: View,
    topDetected: Boolean = false,
    bottomDetected: Boolean = false,
    leftDetected: Boolean = false,
    rightDetected: Boolean = false,
    targetAngle: Int = 90,
) {
    val diff = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        (90 - targetAngle) * (2.6).toFloat(),
        context.resources.displayMetrics
    )

    val (lt, rt, lb, rb) =  arrayOf(
        ContextCompat.getDrawable(
            context,
            context.resources.getIdentifier("card_bounding_${targetAngle}_lt", "drawable", context.packageName))?.toBitmap(),
        ContextCompat.getDrawable(
            context,
            context.resources.getIdentifier("card_bounding_${targetAngle}_rt", "drawable", context.packageName))?.toBitmap(),
        ContextCompat.getDrawable(
            context,
            context.resources.getIdentifier("card_bounding_${targetAngle}_lb", "drawable", context.packageName))?.toBitmap(),
        ContextCompat.getDrawable(
            context,
            context.resources.getIdentifier("card_bounding_${targetAngle}_rb", "drawable", context.packageName))?.toBitmap()
    )

    if (lt != null && rt != null && rb != null && lb != null) {
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val colorFilter: ColorFilter =
            PorterDuffColorFilter(
                ContextCompat.getColor(context, R.color.ClovaGreen),
                PorterDuff.Mode.SRC_ATOP
            ) //(color, mode)

        val scaledDiff = diff * 0.9f

        if (diff >= 0) {
            if (topDetected || leftDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                lt,
                rect.left.toFloat(),
                rect.top.toFloat(),
                paint
            )
            if (topDetected || rightDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                rt,
                rect.right.toFloat() - rt.getScaledWidth(context.resources.displayMetrics),
                rect.top.toFloat(),
                paint
            )
            if (bottomDetected || rightDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                rb,
                rect.right.toFloat() - scaledDiff - rb.getScaledWidth(context.resources.displayMetrics),
                rect.bottom.toFloat() - rb.getScaledHeight(context.resources.displayMetrics),
                paint
            )
            if (bottomDetected || leftDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                lb,
                rect.left.toFloat() + scaledDiff,
                rect.bottom.toFloat() - lb.getScaledHeight(context.resources.displayMetrics),
                paint
            )
        } else {
            if (topDetected || leftDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                lt,
                rect.left.toFloat() - scaledDiff,
                rect.top.toFloat(),
                paint
            )
            if (topDetected || rightDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                rt,
                rect.right.toFloat() + scaledDiff - rt.getScaledWidth(context.resources.displayMetrics),
                rect.top.toFloat(),
                paint
            )
            if (bottomDetected || rightDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                rb,
                rect.right.toFloat() - rb.getScaledWidth(context.resources.displayMetrics),
                rect.bottom.toFloat() - rb.getScaledHeight(context.resources.displayMetrics),
                paint
            )
            if (bottomDetected || leftDetected) {
                paint.colorFilter = colorFilter
            } else {
                paint.colorFilter = null
            }
            this.drawBitmap(
                lb,
                rect.left.toFloat(),
                rect.bottom.toFloat() - lb.getScaledHeight(context.resources.displayMetrics),
                paint
            )
        }
    }
}

fun Canvas.drawCardBorderLines(
    context: Context,
    rect: View,
    colorId: Int,
    topDetected: Boolean = true,
    bottomDetected: Boolean = true,
    leftDetected: Boolean = true,
    rightDetected: Boolean = true,
    targetAngle: Int = 90,
) {
    val paint = Paint().apply {
        color = ContextCompat.getColor(context, colorId)
        style = Paint.Style.STROKE
        strokeWidth = 10f
        isAntiAlias = true
    }

    val diff = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        (90 - targetAngle) * (2.5).toFloat(),
        context.resources.displayMetrics
    )

    val lt = PointF(rect.left.toFloat(), rect.top.toFloat())
    val rt = PointF(rect.right.toFloat(), rect.top.toFloat())
    val lb = PointF(rect.left.toFloat(), rect.bottom.toFloat())
    val rb = PointF(rect.right.toFloat(), rect.bottom.toFloat())

    val path = Path()
    if (diff >= 0) {
        if (topDetected) {
            path.moveTo(lt.x + (paint.strokeWidth / 2), lt.y + (paint.strokeWidth / 2))
            path.lineTo(lt.x + (paint.strokeWidth / 2), lt.y + (paint.strokeWidth / 2))
            path.lineTo(rt.x - (paint.strokeWidth / 2), rt.y + (paint.strokeWidth / 2))
        }
        if (bottomDetected) {
            path.moveTo(rb.x - (paint.strokeWidth / 2) - diff, rb.y - (paint.strokeWidth / 2))
            path.lineTo(rb.x - (paint.strokeWidth / 2) - diff, rb.y - (paint.strokeWidth / 2))
            path.lineTo(lb.x + (paint.strokeWidth / 2) + diff, rb.y - (paint.strokeWidth / 2))
        }
        if (leftDetected) {
            path.moveTo(lt.x + (paint.strokeWidth / 2), lt.y + (paint.strokeWidth / 2))
            path.lineTo(lt.x + (paint.strokeWidth / 2), lt.y + (paint.strokeWidth / 2))
            path.lineTo(lb.x + (paint.strokeWidth / 2) + diff, lb.y - (paint.strokeWidth / 2))
        }
        if (rightDetected) {
            path.moveTo(rt.x - (paint.strokeWidth / 2), rt.y + (paint.strokeWidth / 2))
            path.lineTo(rt.x - (paint.strokeWidth / 2), rt.y + (paint.strokeWidth / 2))
            path.lineTo(rb.x - (paint.strokeWidth / 2) - diff, rb.y - (paint.strokeWidth / 2))
        }
        path.close()
    } else {
        if (topDetected) {
            path.moveTo(lt.x + (paint.strokeWidth / 2) - diff, lt.y + (paint.strokeWidth / 2))
            path.lineTo(lt.x + (paint.strokeWidth / 2) - diff, lt.y + (paint.strokeWidth / 2))
            path.lineTo(rt.x - (paint.strokeWidth / 2) + diff, rt.y + (paint.strokeWidth / 2))
        }
        if (bottomDetected) {
            path.moveTo(rb.x - (paint.strokeWidth / 2) , rb.y - (paint.strokeWidth / 2))
            path.lineTo(rb.x - (paint.strokeWidth / 2) , rb.y - (paint.strokeWidth / 2))
            path.lineTo(lb.x + (paint.strokeWidth / 2) , rb.y - (paint.strokeWidth / 2))
        }
        if (leftDetected) {
            path.moveTo(lt.x + (paint.strokeWidth / 2) - diff, lt.y + (paint.strokeWidth / 2))
            path.lineTo(lt.x + (paint.strokeWidth / 2) - diff, lt.y + (paint.strokeWidth / 2))
            path.lineTo(lb.x + (paint.strokeWidth / 2), lb.y - (paint.strokeWidth / 2))
        }
        if (rightDetected) {
            path.moveTo(rt.x - (paint.strokeWidth / 2) + diff, rt.y + (paint.strokeWidth / 2))
            path.lineTo(rt.x - (paint.strokeWidth / 2) + diff, rt.y + (paint.strokeWidth / 2))
            path.lineTo(rb.x - (paint.strokeWidth / 2), rb.y - (paint.strokeWidth / 2))
        }
        path.close()
    }

    this.drawPath(path, paint)
}
