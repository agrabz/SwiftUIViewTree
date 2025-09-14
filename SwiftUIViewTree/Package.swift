// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIViewTree",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(
            name: "SwiftUIViewTree",
            targets: ["SwiftUIViewTree"]),
    ],
    targets: [
        .target(
            name: "SwiftUIViewTree"),
        .testTarget(
            name: "SwiftUIViewTreeTests",
            dependencies: ["SwiftUIViewTree"]
        ),
    ]
)
