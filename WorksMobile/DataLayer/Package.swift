// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(path: "../DomainLayer")
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: ["Alamofire", "DomainLayer"])
    ]
)
