//
//  DDLScannerManager.m
//  DLScanner
//
//  Created by Brian Sharrief Alim Bowman on 2/6/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

#import "DDLScannerManager.h"

@implementation DDLScannedLicense
@end

@interface DDLScannerManager ()
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) AVCaptureDeviceInput *frontCameraInput, *backCameraInput;
@property (nonatomic) AVCaptureMetadataOutput *output;
@property (nonatomic) UIView *displayView;
@property (nonatomic) dispatch_queue_t serialQueue;
@property (nonatomic) id<QRRecognitionDelegate> delegate;
@end

@implementation DDLScannerManager {
    BOOL chill;
}

- (void)sessionError:(NSNotification *)notification {
    NSLog(@"error %@", notification.userInfo);
}

- (DDLScannerManager *)initWithView:(UIView *)view
                qrRecognitionDelegate:(id<QRRecognitionDelegate>)qrRecognitionDelegate {
    if (self) {
        self = [super init];
        _session = [[AVCaptureSession alloc] init];
        for (AVCaptureDevice *device in [AVCaptureDeviceDiscoverySession
                                         discoverySessionWithDeviceTypes:
  @[AVCaptureDeviceTypeBuiltInDualCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera, AVCaptureDeviceTypeBuiltInWideAngleCamera]
                                         mediaType:nil
                                         position:AVCaptureDevicePositionUnspecified].devices) {
            NSLog(@"discovered device %@ %@", device, device.deviceType);
            NSError *error;
            if (device.position == AVCaptureDevicePositionBack) {
                _backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            } else if (device.position == AVCaptureDevicePositionFront) {
                _frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            }
            NSLog(@"camera error %@", error);
        }
        if (!_backCameraInput && !_frontCameraInput) return self;
        _displayView = view;
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_session beginConfiguration];
        [_session addInput:_backCameraInput ? : _frontCameraInput];
        [_session addOutput:_output];
        [_session commitConfiguration];
        _serialQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
        [_output setMetadataObjectsDelegate:self queue:_serialQueue];
        _output.metadataObjectTypes = _output.availableMetadataObjectTypes;
        _output.rectOfInterest = view.frame;
        [_session startRunning];
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _previewLayer.frame = _displayView.frame;
        [_displayView.layer addSublayer:_previewLayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionError:)
                                                     name:AVCaptureSessionRuntimeErrorNotification
                                                   object:_session];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionError:)
                                                     name:AVCaptureSessionErrorKey
                                                   object:_session];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionError:)
                                                     name:AVCaptureSessionDidStartRunningNotification
                                                   object:_session];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionError:)
                                                     name:AVCaptureSessionDidStopRunningNotification
                                                   object:_session];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sessionError:)
                                                     name:AVCaptureSessionWasInterruptedNotification
                                                   object:_session];
    }

    [_output setMetadataObjectsDelegate:self queue:_serialQueue];
    _delegate = qrRecognitionDelegate;
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataObject *object in metadataObjects) {
        if (object.type == AVMetadataObjectTypePDF417Code) {
            AVMetadataMachineReadableCodeObject *barCodeObject =
            (AVMetadataMachineReadableCodeObject *)
            [self.previewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)object];
            NSString *detectionString = [(AVMetadataMachineReadableCodeObject *)barCodeObject stringValue];
            NSLog(@"%@", detectionString);
            DDLScannedLicense *license = [self licenseObjectFromString:detectionString];
            [self.delegate didScanQRCodeReturningDLScannedLicense:license];
            break;
        } else if (object.type == AVMetadataObjectTypeQRCode) {
            
        }
    }
}

- (DDLScannedLicense *)licenseObjectFromString:(NSString *)string {
    DDLScannedLicense *license = [DDLScannedLicense new];
    for (__strong NSString *line in [string componentsSeparatedByString:@"\n"]) {
        [self addDetailsToLicenseObject:license withLine:line];
    }
    return license;
}

- (void)addDetailsToLicenseObject:(DDLScannedLicense *)licenseObject withLine:(NSString *)scannedString {
    if ([scannedString containsString:@"DAQ"]) {
        licenseObject.licenseNumber = [scannedString componentsSeparatedByString:@"DAQ"].lastObject;
    } else if ([scannedString containsString:@"DAB"] || [scannedString containsString:@"DCS"]) {
        licenseObject.lastName = [scannedString containsString:@"DAB"] ?
        [scannedString componentsSeparatedByString:@"DAB"].lastObject :
        [scannedString componentsSeparatedByString:@"DCS"].lastObject;
    } else if ([scannedString containsString:@"DAC"] || [scannedString containsString:@"DCT"]) {
        licenseObject.firstName = [scannedString containsString:@"DAC"] ?
        [scannedString componentsSeparatedByString:@"DAC"].lastObject :
        [scannedString componentsSeparatedByString:@"DCT"].lastObject;
    } else if ([scannedString containsString:@"DAD"]) {
        licenseObject.middleName = [scannedString componentsSeparatedByString:@"DAD"].lastObject;
    } else if ([scannedString containsString:@"DBA"]) {
        licenseObject.expirationDate = [scannedString componentsSeparatedByString:@"DBA"].lastObject;
    } else if ([scannedString containsString:@"DAG"]) {
        licenseObject.streetAddress = [scannedString componentsSeparatedByString:@"DAG"].lastObject;
    } else if ([scannedString containsString:@"DAI"]) {
        licenseObject.city = [scannedString componentsSeparatedByString:@"DAI"].lastObject;
    } else if ([scannedString containsString:@"DAJ"]) {
        licenseObject.state = [scannedString componentsSeparatedByString:@"DAJ"].lastObject;
    } else if ([scannedString containsString:@"DAK"]) {
        licenseObject.zip = [scannedString componentsSeparatedByString:@"DAK"].lastObject;
    }
}


@end
