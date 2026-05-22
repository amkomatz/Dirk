// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Dirk",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
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
