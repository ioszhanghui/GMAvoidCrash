#
# Be sure to run `pod lib lint GMAvoidCrash.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GMAvoidCrash'
  s.version          = '0.2.0'
  s.summary          = '防崩溃处理.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
常见的崩溃处理
1.NSString
2.NSMutableString
3.NSArray
4.NSMutableArray
5.NSDictionary
6.NSMutableDictionary
7.NSMutableAttributeString
8.@[]数组类型 @{}字典类型
9.unrecognized selector crash
10.KVC 防崩溃处理
                       DESC
                       

  s.homepage         = 'https://github.com/ioszhanghui/GMAvoidCrash.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ioszhanghui@163.com' => 'yomingyo@gmail.com' }
  s.source           = { :git => 'https://github.com/ioszhanghui/GMAvoidCrash.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'GMAvoidCrash/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GMAvoidCrash' => ['GMAvoidCrash/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
