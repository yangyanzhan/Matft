Pod::Spec.new do |spec|
  spec.name           = "Matft"
  spec.version        = "0.2.8"
  spec.summary        = "Numpy-like matrix operation library in swift"
  spec.homepage       = "https://github.com/jjjkkkjjj/Matft"
  spec.license        = { :type => 'BSD-3-Clause', :file => 'LICENSE' }
  spec.author         = "jjjkkkjjj"
  spec.platform       = :ios, "14.0"
  spec.swift_versions = "5"
  spec.pod_target_xcconfig  = { 'SWIFT_VERSION' => '5' }
  spec.source         = { :git => "https://github.com/jjjkkkjjj/Matft.git", :tag => "#{spec.version}" }
  spec.source_files   = "Sources/**/*"
end

