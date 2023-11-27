Detecting card using CLOVA card detector

## Creating instance

You can create a `ClovaCardDetector` instance like the following:

```kotlin
val cardDetector = ClovaCardDetector()
```

## Detecting card

The card detection feature of CLOVA card detector SDK finds the card zone in the provided image and returns it in `ClovaCardResult` form.  
To utilize the card detection feature and detect the card, create an instance of `ClovaCardDetector` and call its `detectCard()` function.

1. Please create a `ClovaCardDetector` instance. You can create an instance with  `ClovaCardDetectoOption` or not

   ```kotlin
   val cardDetectorOptions = ClovaCardDetectorOption()
   
   val cardDetectorWithOptions = ClovaCardDetector(cardDetectorOptions)
   ```

2. Please set the detection options. For detailed description of the detection options, refer to [Using various card detection options for better card detection](./option_AOS.md).

   ```kotlin
   val option = DetectCardOption(
     cardRatio = 1.5858f,
     targetAngle = 90,
     angleOffset = 5,
     minimumSize = 0.65f,	
     checkSideDetected = false,
     checkCameraShaky = false,
     accumulatedFrameCount = 10
   )
   
   val cardDetector = ClovaCardDetector() // or ClovaCardDetector(option)
   cardDetector.setOption(option)
   ```

3. Call the `detectCard()` function to perform card detection

   ```kotlin
   val detectResult = cardDetector.detectCard(image: ClovaVisionImage)      //input image
   ```

The following is a code example that uses the detection result:

```kotlin
detectResult.rectInfo?.let {result ->
    drawRect(result.boundingRect)
}
```

## Card detection results

The `ClovaCardResult` object returned from the `detectCard()` function consists of the following information:

| Items| Description|
|:----------|----------|
| `rectInfo`                     | Class containing bounding box and angle information for the detected card from the input image |
| `rectInfo.angle`               | Angle value of the detected card from the input image `int`  |
| `rectInfo.boundingRect`        | Bounding box zone detected from the input image `Rect`       |
| `rectInfo.topLeft`             | TopLeft of the detected card from the input image `Point`    |
| `rectInfo.topRight`            | TopRight of the detected card from the input image `Point`   |
| `rectInfo.bottomLeft`          | BottomLeft of the detected card from the input image `Point` |
| `rectInfo.bottomRight`         | BottomRight of the detected card from the input image `Point` |
| `rectInfo.cardImage`           | Card image converted to card ratio `ClovaVisionImage`  |
| `sideInfo`                     | Class containing information of the sides (top, bottom, left, right) of the detected card from the input image |
| `sideInfo.topDetected`         | Whether the top side of the card is detected `boolean`         |
| `sideInfo.bottomDetected`      | Whether the bottom side of the card is detected `boolean`      |
| `sideInfo.rightDetected`       | Whether the right side of the card is detected `boolean`       |
| `sideInfo.leftDetected`        | Whether the left side of the card is detected `boolean`        |
| `errorInfo`                    | Error information of the detected card.                      |
| `additionalInfo.isShakyCamera` | Whether the camera is shaking `boolean` |
