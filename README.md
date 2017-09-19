# DDLScannerManager

[![CI Status](http://img.shields.io/travis/2020deception/DDLScannerManager.svg?style=flat)](https://travis-ci.org/2020deception/DDLScannerManager)
[![Version](https://img.shields.io/cocoapods/v/DDLScannerManager.svg?style=flat)](http://cocoapods.org/pods/DDLScannerManager)
[![License](https://img.shields.io/cocoapods/l/DDLScannerManager.svg?style=flat)](http://cocoapods.org/pods/DDLScannerManager)
[![Platform](https://img.shields.io/cocoapods/p/DDLScannerManager.svg?style=flat)](http://cocoapods.org/pods/DDLScannerManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To use this pod in your project, here is a quick example:
```
@interface DDLViewController () <QRRecognitionDelegate>
@property (nonatomic, readonly) DDLScannerManager *scanner;
@end

@implementation DDLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scanner = [[DDLScannerManager alloc] initWithView:self.view
                                 qrRecognitionDelegate:self];
}
    
- (void)didScanQRCodeReturningDLScannedLicense:(DDLScannedLicense *)license {
    NSLog(@"%@ %@", license.firstName, license.lastName);
}

@end
```

this will present a full screen camera view which will scan your code and return the result in the 
```QRRecognitionDelegate``` callback.

## Requirements

## Installation

DDLScannerManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DDLScannerManager'
```

## Author

2020deception, 2020deception@gmail.com

## License

DDLScannerManager is available under the MIT license. See the LICENSE file for more info.
