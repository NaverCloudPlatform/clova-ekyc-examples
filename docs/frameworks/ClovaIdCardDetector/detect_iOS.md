# Detecting id card using CLOVA Id Card Detector

## Creating instance

You can create a `ClovaIdCardDetector` instance like the following:

```swift
let faceDetectorOption = ClovaFaceDetectorOption()
let idCardDetector = ClovaIdCardDetector(option: faceDetectorOption)
```

## Detecting card

The id card detection feature of CLOVA card detector SDK finds the card zone in the provided image and returns it in `ClovaIdCardResult` form.  
To utilize the card detection feature and detect the card, create an instance of `ClovaIdCardDetector` and call its `detectIdCard()` function.

1. Please create a `ClovaIdCardDetector` instance.

```swift
let faceDetectorOption = ClovaFaceDetectorOption()
let idCardDetector = ClovaIdCardDetector(option: faceDetectorOption)
```

2. Please set the detection options. For detailed description of the detection options, refer to [Using various card detection options for better card detection](./option_iOS.md).

```swift
let option = ClovaIdCardDetectorOption()
option.cardRatio = 1.5858
option.targetAngle = 90
option.angleOffset = 5
option.faceLocation = .anyWhere
option.isHDREnabled = true
option.checkSideDetected = false
option.checkCameraShaky = true
option.checkImageDark = true
option.checkImageBlurry = true
option.checkGlareDeteced = true
option.glarePercentage = 0.07
option.accumulatedFrameCount = 10
idCardDetector.setOption(option)
```

3. Call the `detectCard()` function to perform card detection.

```swift
let detectResult = idCardDetector.detectIdCard(with: ClovaVisionImage) // input image
```

The following is a code example that uses the detection result:

```swift
if let rectInfo = detectResult.rectInfo {
    drawRect(rectInfo.boundingRect)
}
```

## Id Card detection results

The `ClovaIdCardResult` object returned from the `detectIdCard()` function consists of the following information:

| Items| Description|
|:----------|----------|
| `rectInfo`                     | Class containing bounding box and angle information for the detected card from the input image |
| `rectInfo.angle`                 | Angle value of the detected card from the input image `Int`  |
| `rectInfo.boundingRect`          | Bounding box zone detected from the input image `CGRect`       |
| `rectInfo.topLeft`               | TopLeft of the detected card from the input image `CGPoint`    |
| `rectInfo.topRight`              | TopRight of the detected card from the input image `CGPoint`   |
| `rectInfo.bottomLeft`            | BottomLeft of the detected card from the input image `CGPoint` |
| `rectInfo.bottomRight`           | BottomRight of the detected card from the input image `CGPoint` |
| `rectInfo.cardImage`             | Card image converted to card ratio `ClovaVisionImage`  |
| `sideInfo`                       | Class containing information of the sides (top, bottom, left, right) of the detected card from the input image |
| `sideInfo.topDetected`           | Whether the top side of the card is detected `Bool`         |
| `sideInfo.bottomDetected`        | Whether the bottom side of the card is detected `Bool`      |
| `sideInfo.rightDetected`         | Whether the right side of the card is detected `Bool`       |
| `sideInfo.leftDetected`          | Whether the left side of the card is detected `Bool`        |
| `errorInfo`                      | Error information of the detected card                      |
| `additionalInfo.isShakyCamera`   | Whether the camera is shaking `Bool`                     |
| `additionalInfo.isBlurryImage` | Whether the detected card zone image is too blurry `Bool` |
| `additionalInfo.isDarkImage` | Whether the detected card zone image is too dark  `Bool` |
| `additionalInfo.isGlareDetected` | Whether the glare is detected in the card image `Bool` |
| `faceInfo` | Detected face information |
| `faceInfo.faceImage` | Detected face image `ClovaVisionImage` |
