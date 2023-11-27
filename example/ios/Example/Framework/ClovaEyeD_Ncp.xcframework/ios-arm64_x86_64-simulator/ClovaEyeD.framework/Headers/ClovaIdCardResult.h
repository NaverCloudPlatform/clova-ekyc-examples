/**
 * Copyright 2023-present NAVER Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ClovaCardResult.h"
#import "ClovaFaceResult.h"
#import "ClovaVisionImage.h"

NS_ASSUME_NONNULL_BEGIN

/// @brief Error information of the detected id card.
@interface ClovaIdCardErrorInfo: NSObject

/// @brief Whether the camera is shaking.
@property (nonatomic, readwrite, assign) bool isShakyCamera;
/// @brief Whether the card image is too blurry.
@property (nonatomic, readwrite, assign) bool isBlurryImage;
/// @brief Whether the card image is too dark.
@property (nonatomic, readwrite, assign) bool isDarkImage;
/// @brief Whether the glare is detected in the card image.
@property (nonatomic, readwrite, assign) bool isGlareDetected;

@end

/// @brief Face information of the detected id card.
@interface ClovaIdCardFaceInfo: NSObject

/// @brief The image of detected face in card.
@property (nonatomic, readonly, strong) ClovaVisionImage* faceImage;

@end

/// @brief Id card result data.
@interface ClovaIdCard: NSObject

/// @brief The ROI information of the detected id card.
@property (nonatomic, readonly, strong, nullable) ClovaCardRectInfo* rectInfo;
/// @brief Information on which each side of the card is detected.
@property (nonatomic, readonly, strong) ClovaCardSideInfo* sideInfo;
/// @brief Error information of the detected id card.
@property (nonatomic, readonly, strong) ClovaIdCardErrorInfo* errorInfo;
/// @brief Face information of the detected id card.
@property (nonatomic, readonly, strong, nullable) ClovaIdCardFaceInfo* faceInfo;

@end

/// @brief Id card shot status type
typedef NS_ENUM(NSUInteger, ClovaIdCardShotStatus) {
    /// Avaiable to shot.
    ClovaIdCardShotStatusAvailable,
    /// Cards are not stacked at the correct level or appropriate cards are not detected.
    ClovaIdCardShotStatusNotAvailable,
    /// The best card shot image is too blurry.
    ClovaIdCardShotStatusBlurError,
    /// Glare is detected in the best card shot image.
    ClovaIdCardShotStatusGlareError,
    /// The best card shot image is too dark.
    ClovaIdCardShotStatusDarkError
};

/// @brief The best id card shot of multiple stacked results.
@interface ClovaIdCardShot: NSObject

/// @brief The ROI information of the detected id card.
@property (nonatomic, readonly, strong) ClovaCardRectInfo* rectInfo;
/// @brief Face information of the detected id card.
@property (nonatomic, readonly, strong, nullable) ClovaIdCardFaceInfo* faceInfo;
/// @brief Source image object taken over from client
@property (nonatomic, readonly, strong) ClovaVisionImage* originImage;

@end

/// @brief The result for id card shot function.
@interface ClovaIdCardShotResult: NSObject

/// @brief Id card shot status.
@property (nonatomic, readonly, assign) ClovaIdCardShotStatus status;
/// @brief The best id card shot of multiple stacked results. Contains value only if the status is available; null if not.
@property (nonatomic, readonly, strong, nullable) ClovaIdCardShot* idCard;

@end

NS_ASSUME_NONNULL_END
