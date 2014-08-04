Pod::Spec.new do |s|

  s.name         = "CombinationPickerController"
  s.version      = "0.0.1"
  s.summary      = "iOS picker"

#  s.description  = <<-DESC
#                   A longer description of CombinationPickerController in Markdown format.
#                   * Think: Why did you write this? What is the focus? What does it do?
#                   * CocoaPods will be using this to generate tags, and improve search results.
#                   * Try to keep it short, snappy and to the point.
#                   * Finally, don't worry about the indent, CocoaPods strips it!
#                   DESC

  s.homepage     = "https://github.com/opendream/CombinationPickerController"
  s.license      = "MIT"
  s.author    = "Opendream"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/opendream/CombinationPickerController.git", :tag => "0.0.1" }
  s.source_files  = 'CombinationPickerContoller', 'CombinationPickerContoller/**/*.{h,m}'  
  s.resources = ["**/*.png", "**/*.xib"]
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  s.frameworks = "QuartzCore", "AssetsLibrary", "Foundation", "UIKit"
  s.requires_arc = true
  s.dependency "KxMenu", "~> 1"

end
