#
# Be sure to run `pod lib lint DDLScannerManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'DDLScannerManager'
s.version          = '0.1.0'
s.summary          = 'Allows you to scan Driver License barcodes and return relevent data.'

s.description      = <<-DESC
Spin up an instance of DLScannerManager. Once the camera is displaying, scan the license.
All relevent data will be returned in the callback.
DESC

s.homepage         = 'https://github.com/2020deception/DDLScannerManager'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '2020deception' => '2020deception@gmail.com' }
s.source           = { :git => 'https://github.com/2020deception/DDLScannerManager.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/2020deception'

s.ios.deployment_target = '8.0'

s.source_files = 'DDLScannerManager/Classes/*'
s.frameworks = 'UIKit', 'Foundation', 'AVFoundation'
end

