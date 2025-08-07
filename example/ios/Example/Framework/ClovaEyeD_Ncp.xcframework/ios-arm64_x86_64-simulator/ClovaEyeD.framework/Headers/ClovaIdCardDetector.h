/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ClovaIdCardResult.h"
#import "ClovaIdCardDetectorOption.h"
#import "ClovaFaceDetectorOption.h"
#import "ClovaVisionImage.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief CLOVA Id Card Detector Class.
@interface ClovaIdCardDetector : NSObject

/// @brief Initialize ClovaIdCardDetector with options.
/// @param option ClovaFaceDetectorOption option to detect a face in id card.
-(id)initWithOption:(ClovaFaceDetectorOption*)option;

/// @brief Set options for the ClovaIdCardDetector.
/// @param option ClovaIdCardDetector option with target card angle, etc.
-(void)setOption:(ClovaIdCardDetectorOption*)option;

/// @brief Detect a id card in ClovaVisionImage.
/// @param image Vision image to detect a id card.
-(ClovaIdCard*)detectIdCardWithImage:(ClovaVisionImage*)image;

/// @brief Shot card based on queuing results. Returns the best id card shot of multiple stacked results.
/// @param threshold Threshold for the number of successful id card detection results that determines the success of the id card shot.
-(ClovaIdCardShotResult*)shotIdCard:(int)threshold
NS_SWIFT_NAME(shotIdCard(threshold:));

/// @brief Reset ClovaIdCardDetector. It clears the result queue to shot id card.
-(void)reset;

@end

NS_ASSUME_NONNULL_END
