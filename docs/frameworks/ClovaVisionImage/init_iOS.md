# Creating CLOVA Vision image

`ClovaVisionImage` can be created as the following:

```swift
let visionImage1 = ClovaVisionImage(sampleBuffer: CMSampleBuffer)
let visionImage2 = ClovaVisionImage(uiImage: UIImage)
let visionImage3 = ClovaVisionImage(rawData: UnsafeMutableRawPointer?, 
                                    width: Int32, 
                                    height: Int32, 
                                    format: ClovaImageFormat, 
                                    rotationDegrees: ClovaRotationDegrees, 
                                    bytesPerRow: Int32)
```
