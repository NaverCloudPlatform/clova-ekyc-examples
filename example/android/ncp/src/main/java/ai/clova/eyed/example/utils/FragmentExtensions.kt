/**
 * Copyright 2021-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

package ai.clova.eyed.example.utils

import android.widget.Toast
import androidx.fragment.app.Fragment

inline fun Fragment.runOnUiThread(crossinline block: () -> Unit) =
    activity?.runOnUiThread {
        block()
    }


fun Fragment.showToastMessage(message: Any, duration: Int) =
    activity?.run {
        runOnUiThread {
            Toast.makeText(this, message.toString(), duration).show()
        }
    }

