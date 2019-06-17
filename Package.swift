// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "MusicTheory",
    products: [
        .library(
            name: "MusicTheory",
            targets: ["MusicTheory"]),
    ],
    targets: [
        .target(
            name: "MusicTheory",
            dependencies: []),
        .testTarget(
            name: "MusicTheoryTests",
            dependencies: ["MusicTheory"]),
    ]
)
