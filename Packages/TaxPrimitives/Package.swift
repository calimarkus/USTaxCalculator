// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaxPrimitives",
    products: [
        .library(
            name: "TaxPrimitives",
            targets: ["TaxPrimitives"]),
    ],
    targets: [
        .target(
            name: "TaxPrimitives"),
        .testTarget(
            name: "TaxPrimitivesTests",
            dependencies: ["TaxPrimitives"]),
    ]
)
