# Using various card detection options for better card detection

## Configuring the detection options

The CLOVA card detector SDK offers various options to detect clearer card images from the input images.  
You can use various options such as light reflection detection and camera shake detection as follows:

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

| Items| Type| Description|
|:----------|:----------|----------|
| `cardRatio`                | Float         | Ratio of id cards to detect |
| `targetAngle`              | Int           | The angle of the card to be detected is calculated as follows:<br/>![Angle](../../images/calculate_angle.jpeg) |
| `angleOffset`              | Int           | Angle offset<br/>[targetAngle - angleOffset <= detection angle <= targetAngle + angleOffset]|
| `minimumSize`              | Float         | Minimum area of the card to be detected (detection card area / card ROI zone `cropRect`)|
| `checkSideDetected`        | Bool          | Whether to detect and return the card sides (top, bottom, left, right)|
| `checkCameraShaky`         | Bool          | Whether to detect camera shake                               |
| `checkImageBlurry`         | Bool          | Whether to detect blur in the card zone                      |
| `checkImageDark`           | Bool          | Whether to detect darkness                                   |
| `checkGlareDetected`       | Float            | Whether to detect light reflection in the card zone          |
| `blurThreshold`            | Float            | Threshold about blur detection                               |
| `darkThreshold`            | Float            | Threshold about dark detection (step 1..10)                  |
| `glarePercentage`          | Float            | Threshold about glare detection (Based on percentage)        |
| `faceLocation`             | `IdFaceLocation` | Set the photo location of the ID card to detect              |
| `IdFaceLocation.anyWhere`  | enum             |                                                              |
| `IdFaceLocation.left`      | enum             |                                                              |
| `IdFaceLocation.right`     | enum             |                                                              |
| `IdFaceLocation.none`      | enum             |                                                              |
| `accumulatedFrameCount`    | Int              | Number of frames to accumulate when using `shotIdCard()` |
