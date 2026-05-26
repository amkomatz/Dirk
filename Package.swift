// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Dirk",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "Dirk", targets: ["Dirk"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Dirk", dependencies: []),
        .testTarget(name: "DirkTests", dependencies: ["Dirk"]),
    ]
)
