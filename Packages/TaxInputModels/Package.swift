// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaxInputModels",
    products: [
        .library(
            name: "TaxInputModels",
            targets: ["TaxInputModels"]),
    ],
    dependencies: [
        .package(name: "TaxPrimitives", path: "../TaxPrimitives")
    ],
    targets: [
        .target(
            name: "TaxInputModels",
            dependencies: [.product(name: "TaxPrimitives", package: "TaxPrimitives")]
        ),
        .testTarget(
            name: "TaxInputModelsTests",
            dependencies: ["TaxInputModels"]),
    ]
)
