/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

@file:JvmName(name = "Logger")

package ai.clova.eyed.example.utils

import android.util.Log

inline val <reified T> T.TAG: String
    get() = T::class.java.simpleName.let { base ->
        if (base.isNullOrEmpty()) {
            T::class.java.name.removePrefix(prefix = "${T::class.java.`package`}.")
        } else {
            base
        }.let {
            "CLOVA>>$base"
        }
    }


fun debug(tag: String, message: Any? = "", throwable: Throwable? = null) =
    Log.d(tag, message(string = message.toString()), throwable)


fun verbose(tag: String, message: Any? = "", throwable: Throwable? = null) =
    Log.v(tag, message(string = message.toString()), throwable)


fun info(tag: String, message: Any? = "", throwable: Throwable? = null) =
    Log.i(tag, message(string = message.toString()), throwable)


fun warn(tag: String, message: Any? = "", throwable: Throwable? = null) =
    Log.w(tag, message(string = message.toString()), throwable)


fun error(tag: String, message: Any? = "", throwable: Throwable? = null) =
    Log.e(tag, message(string = message.toString()), throwable)


private fun message(string: String) =
    Thread.currentThread().stackTrace[5].let { stackTraceElement ->
        buildString {
            append("[[${stackTraceElement.fileName}>")
            append("${stackTraceElement.methodName}>#")
            append("${stackTraceElement.lineNumber}]] $string")
        }
    }





