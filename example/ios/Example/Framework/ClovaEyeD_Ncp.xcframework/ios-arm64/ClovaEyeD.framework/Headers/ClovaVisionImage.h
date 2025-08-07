/**
 * CLOVA EyeD(eKYC)
 * Copyright (c) 2023-present NAVER Cloud Corp.
 * Unauthorized use, modification and redistribution of this software are strongly prohibited.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief Frame pixel format type.
typedef NS_ENUM(NSUInteger, ClovaImageFormat) {
    /// @brief RGBA8888 frame format
    ClovaImageFormatRGBA8888,
    /// @brief BGRA8888 frame format (`kCVPixelFormatType_32BGRA`)
    ClovaImageFormatBGRA8888,
    /// @brief RGB888 frame format
    ClovaImageFormatRGB888,
    /// @brief BGR888 frame format
    ClovaImageFormatBGR888,
    /// @brief NV12 frame format (`kCVPixelFormatType_420YpCbCr8BiPlanarFullRange`)
    ClovaImageFormatNV12,
    /// @brief NV21 frame format
    ClovaImageFormatNV21,
    /// @brief kYUV420P frame format
    ClovaImageFormatkYUV420P,
};

/// @brief Rotation degree type
typedef NS_ENUM(NSUInteger, ClovaRotationDegrees) {
    /// @brief 0 degree rotation (portrait)
    ClovaRotationDegrees0,
    /// @brief 90 degree rotation (clockwise)
    ClovaRotationDegrees90,
    /// @brief 180 degree rotation
    ClovaRotationDegrees180,
    /// @brief 270 degree rotation (counterclockwise)
    ClovaRotationDegrees270
};

/// @brief The container for original input image serving as a source to inferencing.
@interface ClovaVisionImage: NSObject

/// @brief Initialize a ClovaVisionImage instance from a single plane.
/// @param data The target image data
/// @param width The width of the input image in pixels
/// @param height The height of the input image in pixels
/// @param format The image format of the input image
/// @param rotationDegrees The amount of degrees required to make
/// the original image portrait. If the original image is portrait,
/// i.e. a person is standing upright, then set the degree equivalent to 0.
/// Otherwise, set the degree equiavelent to 90 or 270.
/// @param bytesPerRow The number of bytes per row of the input image
-(id)initWithRawData:(nullable void*)data
               width:(int)width
              height:(int)height
              format:(ClovaImageFormat)format
     rotationDegrees:(ClovaRotationDegrees)rotationDegrees
         bytesPerRow:(int)bytesPerRow;

/// @brief Initialize a ClovaVisionImage instance from separated planes. (e.g., Y-plane + UV-plane)
/// @param dataPlane1 The first target image data
/// @param dataPlane2 The second target image data
/// @param width The width of the input image in pixels
/// @param height The height of the input image in pixels
/// @param format The image format of the input image
/// @param rotationDegrees The amount of degrees required to make
/// the original image portrait. If the original image is portrait,
/// i.e. a person is standing upright, then set the degree equivalent to 0.
/// Otherwise, set the degree equiavelent to 90 or 270.
/// @param bytesPerRowPlane1 The number of bytes per row of the first image data
/// @param bytesPerRowPlane2 The number of bytes per row of the second image data
-(id)initWithRawDataPlane1:(nullable void*)dataPlane1
             rawDataPlane2:(nullable void*)dataPlane2
                     width:(int)width
                    height:(int)height
                    format:(ClovaImageFormat)format
           rotationDegrees:(ClovaRotationDegrees)rotationDegrees
         bytesPerRowPlane1:(int)bytesPerRowPlane1
         bytesPerRowPlane2:(int)bytesPerRowPlane2;

/// @brief Creates a vision image using the data contained within a subregion of an existing vision image.
/// @param rect A rectangle specifying the portion of the image to keep.
-(nullable ClovaVisionImage*)cropWithRect:(CGRect)rect;

/// @brief Initializes and returns an UIImage object
-(UIImage*)uiImage;

/// @brief Returns the width of the origin image.
-(int)width;

/// @brief Returns the height of the origin image.
-(int)height;

@end


NS_ASSUME_NONNULL_END
