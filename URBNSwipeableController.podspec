#
# Be sure to run `pod lib lint URBNSwipeableController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'URBNSwipeableController'
  s.version          = '0.2.0'
  s.summary          = 'URBNSwipeableController allows you to add swiping to any tableviewcell, collectionviewcell, or any old view.'
  s.homepage         = 'https://github.com/urbn/URBNDataSource'
  s.license          = 'MIT'
  s.author           = { "URBN" => "mobileteam@urbn.com" }
  s.source           = { :git => "https://github.com/urbn/URBNSwipeableController.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m}'
end