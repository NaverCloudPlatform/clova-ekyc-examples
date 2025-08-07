/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ClovaVisionImage.h"

NS_ASSUME_NONNULL_BEGIN

@class ClovaVisionImage;

/// @brief The ROI information of the detected card.
@interface ClovaCardRectInfo: NSObject

/// @brief Tilted angle of the detected card rectangle.
@property (nonatomic, readonly, assign) int angle;
/// @brief Top left point of the detected card rectangle.
@property (nonatomic, readonly, assign) CGPoint topLeft;
/// @brief Top right point of the detected card rectangle.
@property (nonatomic, readonly, assign) CGPoint topRight;
/// @brief Bottom left point of the detected card rectangle.
@property (nonatomic, readonly, assign) CGPoint bottomLeft;
/// @brief Bottom right point of the detected card rectangle.
@property (nonatomic, readonly, assign) CGPoint bottomRight;
/// @brief The bounding rectangle area of the detected card.
@property (nonatomic, readonly, assign) CGRect boundingRect;
/// @brief The card image converted to card ratio  based on the tilt angle.
@property (nonatomic, readonly, strong) ClovaVisionImage* cardImage;

@end

/// @brief Information on which each side of the card is detected.
@interface ClovaCardSideInfo: NSObject

/// @brief Whether the top side of the card is detected.
@property (nonatomic, readonly, assign) bool topDetected;
/// @brief Whether the bottom side of the card is detected.
@property (nonatomic, readonly, assign) bool bottomDetected;
/// @brief Whether the right side of the card is detected.
@property (nonatomic, readonly, assign) bool rightDetected;
/// @brief Whether the left side of the card is detected.
@property (nonatomic, readonly, assign) bool leftDetected;

@end

/// @brief Error information of the detected card.
@interface ClovaCardErrorInfo: NSObject

/// @brief Whether the camera is shaking.
@property (nonatomic, readwrite, assign) bool isShakyCamera;

@end

/// @brief Card result data.
@interface ClovaCard: NSObject

/// @brief The ROI information of the detected card.
@property (nonatomic, readonly, strong, nullable) ClovaCardRectInfo* rectInfo;
/// @brief Information on which each side of the card is detected.
@property (nonatomic, readonly, strong) ClovaCardSideInfo* sideInfo;
/// @brief Error information of the detected card.
@property (nonatomic, readonly, strong) ClovaCardErrorInfo* errorInfo;

@end

/// @brief Card shot status type
typedef NS_ENUM(NSUInteger, ClovaCardShotStatus) {
    /// Avaiable to shot.
    ClovaCardShotStatusAvailable,
    /// Cards are not stacked at the correct level or appropriate cards are not detected.
    ClovaCardShotStatusNotAvailable
};

/// @brief The best card shot of multiple stacked results.
@interface ClovaCardShot: NSObject

/// @brief The ROI information of the detected card.
@property (nonatomic, readonly, strong) ClovaCardRectInfo* rectInfo;
/// @brief Source image object taken over from client
@property (nonatomic, readonly, strong) ClovaVisionImage* originImage;

@end

/// @brief The result for card shot function.
@interface ClovaCardShotResult: NSObject

/// @brief Card shot status.
@property (nonatomic, readonly, assign) ClovaCardShotStatus status;
/// @brief The best card shot of multiple stacked results. Contains value only if the status is available; null if not.
@property (nonatomic, readonly, strong, nullable) ClovaCardShot* card;

@end

NS_ASSUME_NONNULL_END
