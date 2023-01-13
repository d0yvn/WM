// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PresentationLayer",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PresentationLayer",
            targets: ["PresentationLayer"])
    ],
    dependencies: [
        .package(path: "../DomainLayer"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        .target(
            name: "PresentationLayer",
            dependencies: ["Kingfisher", "DomainLayer"])
    ]
)
