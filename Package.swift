// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseServicesManager",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FirebaseServicesManager",
            targets: ["FirebaseServicesManager"]),
    ],
    dependencies: [
         .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.9.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "FirebaseServicesManager",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk")
            ]),
        .testTarget(
            name: "FirebaseServicesManagerTests",
            dependencies: ["FirebaseServicesManager"]),
    ]
)
