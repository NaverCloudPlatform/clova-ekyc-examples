# Detecting id card using CLOVA Id Card Detector

## Creating instance

You can create a `ClovaIdCardDetector` instance like the following:

```kotlin
val faceDetectorOption = ClovaFaceDetectorOption()

val idCardDetector = ClovaIdCardDetector(faceDetectorOption)
```

## Detecting card

The id card detection feature of CLOVA card detector SDK finds the card zone in the provided image and returns it in `ClovaIdCardResult` form.  
To utilize the card detection feature and detect the card, create an instance of `ClovaIdCardDetector` and call its `detectIdCard()` function.

1. Please create a `ClovaIdCardDetector` instance.

   ```kotlin
   val faceDetectorOption = ClovaFaceDetectorOption()
   
   val idCardDetector = ClovaIdCardDetector(faceDetectorOption)
   ```

2. Please set the detection options. For detailed description of the detection options, refer to [Using various card detection options for better card detection](./option_AOS.md).

   ```kotlin
   val option = ClovaIdCardDetectorOption(
     cardRatio = 1.5858f,
     targetAngle = 90,
     angleOffset = 5,
     minimumSize = 0.65f,
     checkSideDetected = false,
     checkCameraShaky = false,
     checkImageBlurry = false,
     checkImageDark = false,
     checkGlareDetected = false,
     blurThreshold = 0.13f,
     darkThreshold = 7,
     glarePercentage = 0.05f,
     faceLocation: IdFaceLocation = IdFaceLocation.ANY_WHERE,
     accumulatedFrameCount = 10
   )
   
   idcardDetector.setOption(option)
   ```

3. Call the `detectCard()` function to perform card detection.

   ```kotlin
   val detectResult = idCardDetector.detectIdCard(image: ClovaVisionImage) // input image
   ```

The following is a code example that uses the detection result:

```kotlin
detectResult.rectInfo?.let {result ->
    drawRect(result.boundingRect)
    drawAngle(result.angle)
}
```

## Id Card detection results

The `ClovaIdCardResult` object returned from the `detectIdCard()` function consists of the following information:

| Items| Description|
|:----------|----------|
| `rectInfo`                     | Class containing bounding box and angle information for the detected card from the input image |
| `rectInfo.angle`                 | Angle value of the detected card from the input image `int`  |
| `rectInfo.boundingRect`          | Bounding box zone detected from the input image `Rect`       |
| `rectInfo.topLeft`               | TopLeft of the detected card from the input image `Point`    |
| `rectInfo.topRight`              | TopRight of the detected card from the input image `Point`   |
| `rectInfo.bottomLeft`            | BottomLeft of the detected card from the input image `Point` |
| `rectInfo.bottomRight`           | BottomRight of the detected card from the input image `Point` |
| `rectInfo.cardImage`             | Card image converted to card ratio `ClovaVisionImage` |
| `sideInfo`                       | Class containing information of the sides (top, bottom, left, right) of the detected card from the input image |
| `sideInfo.topDetected`           | Whether the top side of the card is detected `boolean`         |
| `sideInfo.bottomDetected`        | Whether the bottom side of the card is detected `boolean`      |
| `sideInfo.rightDetected`         | Whether the right side of the card is detected `boolean`       |
| `sideInfo.leftDetected`          | Whether the left side of the card is detected `boolean`        |
| `errorInfo`                      | Error information of the detected card.                      |
| `additionalInfo.isShakyCamera`   | Whether the camera is shaking  `boolean`                     |
| `additionalInfo.isBlurryImage` | Whether the detected card zone image is too blurry `boolean` |
| `additionalInfo.isDarkImage` | Whether the detected card zone image is too dark  `boolean` |
| `additionalInfo.isGlareDetected` | Whether the glare is detected in the card image `boolean` |
| `faceInfo` | Detected face information |
| `faceInfo.faceImage` | Detected face image `ClovaVisionImage` |
