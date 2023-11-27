# Cropping CLOVA vision image

The created `ClovaVisionImage` can be cropped as much as the zone of `Rect` or `View` through the `Crop()` function.

```kotlin
val croppedImageByRect: ClovaVisionImage = visionImage.crop(rect = Rect(left, top, right, bottom))
val croppedImageByView: ClovaVisionImage = visionImage.crop(
    parent = View,
    mask = View,
    extraSize = 15(Pixel) // Padding Size
)
```
