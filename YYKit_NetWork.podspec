#
# Be sure to run `pod lib lint YYKit_NetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YYKit_NetWork'
  s.version          = '0.1.0'
  s.summary          = '基于 Swift Moya 封装的网络库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/gbetter/iOSGBetterSpace'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gbeter' => '1246233242@qq.com' }
  s.source           = { :git => 'https://github.com/gbetter/YYKit_NetWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'YYKit_NetWork/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YYKit_NetWork' => ['YYKit_NetWork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
   s.dependency 'Moya/RxSwift', '~> 15.0.0'
   s.dependency 'HandyJSON'
   s.dependency 'iProgressHUD'
   

end
