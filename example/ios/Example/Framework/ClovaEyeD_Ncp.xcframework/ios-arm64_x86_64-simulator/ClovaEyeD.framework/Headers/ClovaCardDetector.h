/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ClovaCardResult.h"
#import "ClovaCardDetectorOption.h"
#import "ClovaVisionImage.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief CLOVA Card Detector Class.
@interface ClovaCardDetector : NSObject

/// @brief Initialize ClovaCardDetector with options.
-(id)init;

/// @brief Set options for the ClovaCardDetector.
/// @param option ClovaCardDetector option with target card angle, etc.
-(void)setOption:(ClovaCardDetectorOption*)option;

/// @brief Detect a card in ClovaVisionImage.
/// @param image Vision image to detect a card.
-(ClovaCard*)detectCardWithImage:(ClovaVisionImage*)image;

/// @brief Shot card based on queuing results. Returns the best card shot of multiple stacked results.
/// @param threshold Threshold for the number of successful card detection results that determines the success of the card shot.
-(ClovaCardShotResult*)shotCard:(int)threshold
NS_SWIFT_NAME(shotCard(threshold:));

/// @brief Reset ClovaCardDetector. It clears the result queue to shot card.
-(void)reset;

@end

NS_ASSUME_NONNULL_END
