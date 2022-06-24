#
# Be sure to run `pod lib lint XCategories.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XHYCategories'
  s.version          = '0.1.1'
  s.summary          = 'A short description of XCategories.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xuhaoyuan/XCategories'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xuhaoyuan' => 'haoyuan.xu@duodian.com' }
  s.source           = { :git => 'https://github.com/xuhaoyuan/XCategories.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'

  s.source_files = 'XCategories/**/*'
  
  s.frameworks = 'UIKit'

  s.dependency 'SnapKit'

end
