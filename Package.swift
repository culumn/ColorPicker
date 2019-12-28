// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorPicker",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "ColorPicker",
            targets: ["ColorPicker"]),
    ],
    targets: [
        .target(
            name: "ColorPicker",
            path: "ColorPicker/")
    ]
)

