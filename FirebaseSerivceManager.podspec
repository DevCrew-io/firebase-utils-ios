Pod::Spec.new do |s|
  s.name             = 'FirebaseSerivceManager'
  s.version          = '1.0.0'
  s.summary          = 'FirebaseSerivceManager is package for Firebase Firestore, Storage and Database'
  s.description      = 'An iOS library that offers a range of utilities for Firestore and Fire Storage, including CRUD operations and other essential functions.'
  s.homepage         = 'https://github.com/DevCrew-io/firebase-utils-ios'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'DevCrew.IO' => 'founders@devcrew.io' }
  
  s.requires_arc = true
  s.swift_version = "5.0"
  s.ios.deployment_target = "10.0"
  
  s.source           = { :git => "https://github.com/DevCrew-io/firebase-utils-ios.git", :tag => s.version }
  s.source_files     = 'Sources/**/*.swift'
  s.dependency 'Firebase/Firestore'
  s.dependency 'Firebase/Storage'
  s.dependency 'Firebase/Database'
end
