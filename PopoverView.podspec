#
# Be sure to run `pod lib lint PopoverView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PopoverView'
  s.version          = '1.0.0'
  s.summary          = 'iOS Common Dropdown popover view.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/vaibhav7a/DropDownPopover.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Vaibhav Jain' => 'vaibhav.jain@jci.com' }
  #s.source       = { :path => '.' }
  s.source           = { :git => 'https://github.com/vaibhav7a/DropDownPopover.git', :tag => 'release_1.0.0' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'PopoverView/**/*'
  
  # s.resource_bundles = {
  #   'PopoverView' => ['PopoverView/Assets/*.png','PopoverView/**/*.xib']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
