// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIViewTree",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "SwiftUIViewTree",
            targets: ["SwiftUIViewTree"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.1.1"),
    ],
    targets: [
        .target(
            name: "SwiftUIViewTree",
            dependencies: [
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            ],
            path: "SwiftUIViewTree/Sources"
        ),
        .testTarget(
            name: "SwiftUIViewTreeTests",
            dependencies: ["SwiftUIViewTree"]
        ),
    ]
)
