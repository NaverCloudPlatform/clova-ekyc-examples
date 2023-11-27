/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.result

import ai.clova.eyed.face.data.ClovaFace
import android.graphics.Bitmap
import androidx.annotation.Keep

@Keep
data class FaceScanResult(
    val faceImage: Bitmap,
    val face: ClovaFace
)