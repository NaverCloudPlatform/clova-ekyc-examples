/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

@file:JvmName(name = "ImageSaver")

package ai.clova.eyed.example.utils

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.Matrix
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import androidx.exifinterface.media.ExifInterface
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

@Throws(IllegalArgumentException::class)
fun Context?.saveImage(fileName: String, mimeType: String, bitmap: Bitmap): Uri? {
    val values = ContentValues()
    with(values) {
        put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
        put(MediaStore.Images.Media.MIME_TYPE, mimeType)
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        values.put(MediaStore.Images.Media.IS_PENDING, 1)
    }

    val uri = this?.contentResolver?.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)

    if (uri != null) {
        val descriptor = this?.contentResolver?.openFileDescriptor(uri, "w")

        if (descriptor != null) {
            val fos = FileOutputStream(descriptor.fileDescriptor)
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos)
            fos.close()

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                values.clear()
                values.put(MediaStore.Images.Media.IS_PENDING, 0)
                this?.contentResolver?.update(uri, values, null, null)
            }
        }
    }

    return uri
}


fun Context?.uriToPath(contentUri: Uri): String? {
    val proj = arrayOf(MediaStore.Images.Media.DATA)
    val cursor: Cursor? = this?.contentResolver?.query(contentUri, proj, null, null, null)
    cursor?.let {
        cursor.moveToNext()
        val index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
        val path = cursor.getString(index)
        cursor.close()
        return path
    }
    return null
}


@Throws(IOException::class)
fun modifyOrientation(bitmap: Bitmap?, image_absolute_path: String): Bitmap? {
    val ei = ExifInterface(image_absolute_path)
    if(bitmap == null)
        return null
    return when (ei.getAttributeInt(
        ExifInterface.TAG_ORIENTATION,
        ExifInterface.ORIENTATION_NORMAL
    )) {
        ExifInterface.ORIENTATION_ROTATE_90 -> rotateBitmap(bitmap, 90f)
        ExifInterface.ORIENTATION_ROTATE_180 -> rotateBitmap(bitmap, 180f)
        ExifInterface.ORIENTATION_ROTATE_270 -> rotateBitmap(bitmap, 270f)
        ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> flipBitmap(
            bitmap,
            horizontal = true,
            vertical = false
        )
        ExifInterface.ORIENTATION_FLIP_VERTICAL -> flipBitmap(
            bitmap,
            horizontal = false,
            vertical = true
        )
        else -> bitmap
    }
}


fun rotateBitmap(bitmap: Bitmap, degrees: Float): Bitmap? {
    val matrix = Matrix()
    matrix.postRotate(degrees)
    return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
}


fun flipBitmap(bitmap: Bitmap, horizontal: Boolean, vertical: Boolean): Bitmap? {
    val matrix = Matrix()
    matrix.preScale(if (horizontal) -1f else 1f, if (vertical) -1f else 1f)
    return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
}

internal fun bitmapToFile(
    image: Bitmap,
    path: File,
    name: String,
    format: Bitmap.CompressFormat = Bitmap.CompressFormat.JPEG,
    quality: Int = 100
): File {
    val file = File(path, name)
    val stream = BufferedOutputStream(FileOutputStream(file))
    image.compress(format, quality, stream)
    stream.close()
    return file
}

