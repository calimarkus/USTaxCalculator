// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaxOutputModels",
    products: [
        .library(
            name: "TaxOutputModels",
            targets: ["TaxOutputModels"]),
    ],
    dependencies: [
        .package(name: "TaxInputModels", path: "../TaxInputModels"),
        .package(name: "TaxPrimitives", path: "../TaxPrimitives"),
        .package(name: "TaxRates", path: "../TaxRates")
    ],
    targets: [
        .target(
            name: "TaxOutputModels",
            dependencies: [
                .product(name: "TaxInputModels", package: "TaxInputModels"),
                .product(name: "TaxPrimitives", package: "TaxPrimitives"),
                .product(name: "TaxRates", package: "TaxRates")
            ]
        ),
        .testTarget(
            name: "TaxOutputModelsTests",
            dependencies: ["TaxOutputModels"]),
    ]
)
