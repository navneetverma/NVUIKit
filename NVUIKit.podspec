Pod::Spec.new do |spec|
  spec.name         = 'NVUIKit'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/navneetverma'
  spec.authors      = { 'Navneet Verma' => 'nverma989@gmail.com' }
  spec.summary      = 'A reusable ui framework.'
  spec.source       = { :git => 'https://github.com/navneetverma/NVUIKit.git', :tag => 'master' }
  spec.source_files = 'Sources/NVUIKit/**/*'
  spec.ios.deployment_target = "9.0"
  spec.dependency 'BonMot'

end