//
//  DDLScannerManager.h
//  DLScanner
//
//  Created by Brian Sharrief Alim Bowman on 2/6/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

@import Foundation;
@import UIKit;
@import AVFoundation;


NS_ASSUME_NONNULL_BEGIN

@interface DDLScannedLicense : NSObject
@property (nonatomic, nullable) NSString
*licenseNumber,
*firstName,
*lastName,
*middleName,
*expirationDate,
*streetAddress,
*city,
*state,
*zip;
@end

@protocol QRRecognitionDelegate <NSObject>
- (void)didScanQRCodeReturningDLScannedLicense:(DDLScannedLicense *)license;
@end
@interface DDLScannerManager : NSObject <AVCaptureMetadataOutputObjectsDelegate>
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/** sessionWithView will add a capture input/output to the layer of the view property
 @param view is the view to display the output
 @param qrRecognitionDelegate is the delegate which returns pertanent information from the scanning */
- (DDLScannerManager *)initWithView:(UIView *)view
                qrRecognitionDelegate:(id<QRRecognitionDelegate>)qrRecognitionDelegate NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END
