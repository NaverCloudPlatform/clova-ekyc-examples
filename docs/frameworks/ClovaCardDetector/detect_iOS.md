Detecting card using CLOVA card detector

## Creating instance

You can create a `ClovaCardDetector` instance like the following:

```swift
let cardDetector = ClovaCardDetector()
```

## Detecting card

The card detection feature of CLOVA card detector SDK finds the card zone in the provided image and returns it in `ClovaCardResult` form.  
To utilize the card detection feature and detect the card, create an instance of `ClovaCardDetector` and call its `detectCard()` function.

1. Please create a `ClovaCardDetector` instance. You can create an instance with  `ClovaCardDetectoOption` or not

   ```swift
   let cardDetectorOptions = ClovaCardDetectorOption()
   let cardDetectorWithOptions = ClovaCardDetector()
   cardDetectorWithOptions.setOption(cardDetectorOptions)
   ```

2. Please set the detection options. For detailed description of the detection options, refer to [Using various card detection options for better card detection](./option_iOS.md).

```swift
let option = ClovaCardDetectorOption()
option.cardRatio = 1.5858
option.targetAngle = 90
option.angleOffset = 5
option.checkSideDetected = false
option.checkCameraShaky = true
option.accumulatedFrameCount = 10
cardDetector.setOption(option)
```

3. Call the `detectCard()` function to perform card detection

```swift
let detectResult = cardDetector.detectCard(with: ClovaVisionImage) // input image
```

The following is a code example that uses the detection result:

```swift
if let rectInfo = detectResult.rectInfo {
    drawRect(rectInfo.boundingRect)
}
```

## Card detection results

The `ClovaCardResult` object returned from the `detectCard()` function consists of the following information:

| Items| Description|
|:----------|----------|
| `rectInfo`                     | Class containing bounding box and angle information for the detected card from the input image |
| `rectInfo.angle`               | Angle value of the detected card from the input image `Int`  |
| `rectInfo.boundingRect`        | Bounding box zone detected from the input image `CGRect`       |
| `rectInfo.topLeft`             | TopLeft of the detected card from the input image `CGPoint`    |
| `rectInfo.topRight`            | TopRight of the detected card from the input image `CGPoint`   |
| `rectInfo.bottomLeft`          | BottomLeft of the detected card from the input image `CGPoint` |
| `rectInfo.bottomRight`         | BottomRight of the detected card from the input image `CGPoint` |
| `rectInfo.cardImage`           | Card image converted to card ratio `ClovaVisionImage`  |
| `sideInfo`                     | Class containing information of the sides (top, bottom, left, right) of the detected card from the input image |
| `sideInfo.topDetected`         | Whether the top side of the card is detected `Bool`         |
| `sideInfo.bottomDetected`      | Whether the bottom side of the card is detected `Bool`      |
| `sideInfo.rightDetected`       | Whether the right side of the card is detected `Bool`       |
| `sideInfo.leftDetected`        | Whether the left side of the card is detected `Bool`        |
| `errorInfo`                    | Error information of the detected card                      |
| `additionalInfo.isShakyCamera` | Whether the camera is shaking `Bool` |
