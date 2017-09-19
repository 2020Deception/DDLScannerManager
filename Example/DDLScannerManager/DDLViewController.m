//
//  DDLViewController.m
//  DDLScannerManager
//
//  Created by 2020deception on 09/19/2017.
//  Copyright (c) 2017 2020deception. All rights reserved.
//

#import "DDLViewController.h"
#import "DDLScannerManager.h"

@interface DDLViewController () <QRRecognitionDelegate>
@property (nonatomic, readonly) DDLScannerManager *scanner;
@end

@implementation DDLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scanner = [[DDLScannerManager alloc] initWithView:self.view
                                       captureDelegate:_scanner
                                 qrRecognitionDelegate:self];
}
    
- (void)didScanQRCodeReturningDLScannedLicense:(DDLScannedLicense *)license {
    NSLog(@"%@ %@", license.firstName, license.lastName);
}

@end
