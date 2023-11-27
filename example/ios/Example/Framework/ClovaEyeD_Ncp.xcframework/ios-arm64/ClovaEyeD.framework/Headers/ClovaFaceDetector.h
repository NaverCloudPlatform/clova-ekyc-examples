/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ClovaFaceResult.h"
#import "ClovaFaceDetectorOption.h"
#import "ClovaVisionImage.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief CLOVA Face Detector Class.
@interface ClovaFaceDetector : NSObject

/// @brief Initializes a face detector with options.
/// @param option ClovaFaceDetectorOption option to detect faces.
-(id)initWithOption:(ClovaFaceDetectorOption*)option;

/// @brief Detects faces in the image.
/// @param image The image to proceed detecting faces.
/// @return The face detection result object.
-(ClovaFaceResult*)detectFace:(ClovaVisionImage*)image;

/// @brief Get similarity value between two faces.
/// @param face1 The first face object to compare.
/// @param face2 The second face object to compare.
/// @return The similarity value.
+(float)getSimilarity:(ClovaFace*)face1
                     :(ClovaFace*)face2;

@end

NS_ASSUME_NONNULL_END
