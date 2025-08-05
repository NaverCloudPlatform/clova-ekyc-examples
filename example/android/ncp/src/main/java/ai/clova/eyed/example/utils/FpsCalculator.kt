/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.utils

import kotlin.math.roundToInt

class FpsCalculator {
    private var frameCounter = 0
    private var lastFPSTimestamp = System.currentTimeMillis()
    var fps = 0
        private set

    fun calculateFPS() {
        val frameCount = 10
        if (++frameCounter % frameCount == 0) {
            frameCounter = 0
            val now = System.currentTimeMillis()
            val delta = now - lastFPSTimestamp
            fps = (1000 * frameCount.toFloat() / delta).roundToInt()
            lastFPSTimestamp = now
        }
    }
}