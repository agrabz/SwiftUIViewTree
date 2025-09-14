// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIViewTreeKit",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "SwiftUIViewTreeKit",
            targets: ["SwiftUIViewTreeKit"]),
    ],
    targets: [
        .target(
            name: "SwiftUIViewTreeKit"),
        .testTarget(
            name: "SwiftUIViewTreeKitTests",
            dependencies: ["SwiftUIViewTreeKit"]
        ),
    ]
)
