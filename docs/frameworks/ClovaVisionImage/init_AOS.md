# Creating CLOVA Vision image

`ClovaVisionImage` can be created as the following:

```kotlin
data class ClovaVisionImage(
    var data: ByteArray,
    var width: Int,
    var height: Int,
    var imageFormat: ImageFormat = ImageFormat.RGBA8888,
    var rotationDegrees: RotationDegrees = RotationDegrees.D0,
    var isFlip: Boolean = false
) {

    /**
     * The frame type of a image
     */
    enum class ImageFormat(val value: Int) {
        RGBA8888(value = 0),
        BGRA8888(value = 1),
        RGB888(value = 2),
        BGR888(value = 3),
        NV12(value = 4),
        NV21(value = 5),
        YV12(value = 6)
    }

    /**
     * The degree type of image rotation
     */
    enum class RotationDegrees(val value: Int) {
        D0(value = 0),
        D90(value = 90),
        D180(value = 180),
        D270(value = 270);
    }
```

Creating `ClovaVisionImage` from camera buffer

```kotlin
// Input the buffer data of camera image.
val bufferSize = cameraBuffer.remaining()

val byteArray = ByteArray(size = bufferSize).apply {
    cameraBuffer.get(this, 0, rgbaSize)
}

ClovaVisionImage(
    byteArray,
    image.width,
    image.height,
    ClovaVisionImage.ImageFormat.RGBA8888,
    ClovaVisionImage.RotationDegrees.valueOf(image.imageInfo.rotationDegrees),
    isMirroredImage
)
```