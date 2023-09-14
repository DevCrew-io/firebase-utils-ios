Pod::Spec.new do |s|
  s.name             = 'FirebaseServicesManager'
  s.version          = '1.0.0'
  s.summary          = 'FirebaseServicesManager is a package for Firebase Firestore, Storage, and Database'
  s.description      = 'An iOS library that offers a range of utilities for Firestore and Firebase Storage, including CRUD operations and other essential functions.'
  s.homepage         = 'https://github.com/DevCrew-io/firebase-utils-ios'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'DevCrew.IO' => 'founders@devcrew.io' }

  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.swift_version = "5.0"

  s.prefix_header_file      = false
  s.requires_arc            = true
  
  s.source           = { :git => "https://github.com/DevCrew-io/firebase-utils-ios.git", :tag => s.version }
  s.source_files     = 'Sources/**/*.swift'
  
  s.dependency 'FirebaseCore'
  s.dependency 'FirebaseFirestore'
  s.dependency 'FirebaseStorage'
  s.dependency 'FirebaseDatabase'
end
