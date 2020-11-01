// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Dirk",
    products: [
        .library(name: "Dirk", targets: ["Dirk"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Dirk", dependencies: []),
        .testTarget(name: "DirkTests", dependencies: ["Dirk"]),
    ]
)
