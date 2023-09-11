

Pod::Spec.new do |spec|

  spec.name         = "FirebaseSerivceManager"
  spec.version      = "1.0.0"
  spec.summary      = "FirebaseSerivceManager is package for Firestore, Storage and "
  spec.description  = "An iOS library that offers a range of utilities for Firestore and Fire Storage, including CRUD operations and other essential functions."
  spec.homepage     = "https://github.com/DevCrew-io/firebase-utils-ios"
  
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.author = { "DevCrew-io" => "sanjeev.gautam@xyz.com" }
  spec.platform = :ios, "13.0"
  spec.swift_version = '5.0'
  spec.source = { :git => "https://github.com/DevCrew-io/firebase-utils-ios.git", :tag => '1.0.0' }
  spec.source_files = "FirebaseSerivceManager/Source/FirebaseServiceManager/**/*.{swift}"

end
