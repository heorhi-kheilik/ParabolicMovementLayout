// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "ParabolicMovementLayout",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ParabolicMovementLayout",
            targets: ["ParabolicMovementLayout"]
        )
    ],
    targets: [
        .target(
            name: "ParabolicMovementLayout"
        )
    ]
)
