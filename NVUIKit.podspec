Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "NVUIKit"
s.summary = "NVUIKit is a reusable UIKit"
s.requires_arc = true
s.version = "0.1.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Navneet Verma" => "nverma989@gmail.com" }
s.homepage = "https://github.com/navneetverma"
s.source = { :git => "https://github.com/navneetverma/NVUIKit.git", 
             :tag => "#{s.version}" }
s.framework = "UIKit"
s.source_files = "Sources/NVUIKit/**/*.{swift}"
s.swift_version = "4.2"
end