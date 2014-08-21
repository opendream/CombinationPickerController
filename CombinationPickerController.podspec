Pod::Spec.new do |s|
  s.name         = "CombinationPickerController"
  s.version      = "0.0.6"
  s.summary      = "iOS picker"
  s.homepage     = "https://github.com/opendream/CombinationPickerController"
  s.license      = "MIT"
  s.author    = "Opendream"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/opendream/CombinationPickerController.git", :tag => "0.0.6" }
  s.source_files  = 'CombinationPickerContoller/Classes/**/*.{h,m}'  
  s.resources = ["**/*.png", "**/*.xib"]
  s.frameworks = "QuartzCore", "AssetsLibrary", "Foundation", "UIKit"
  s.requires_arc = true
  s.dependency "KxMenu", "~> 1"

end
