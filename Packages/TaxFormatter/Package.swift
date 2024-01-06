// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaxFormatter",
    products: [
        .library(
            name: "TaxFormatter",
            targets: ["TaxFormatter"]),
    ],
    dependencies: [
        .package(name: "TaxOutputModels", path: "../TaxOutputModels"),
        .package(name: "TaxInputModels", path: "../TaxInputModels"),
        .package(name: "TaxPrimitives", path: "../TaxPrimitives"),
        .package(name: "TaxRates", path: "../TaxRates")
    ],
    targets: [
        .target(
            name: "TaxFormatter",
            dependencies: [
                .product(name: "TaxOutputModels", package: "TaxOutputModels"),
                .product(name: "TaxInputModels", package: "TaxInputModels"),
                .product(name: "TaxPrimitives", package: "TaxPrimitives"),
                .product(name: "TaxRates", package: "TaxRates")
            ]
        ),
        .testTarget(
            name: "TaxFormatterTests",
            dependencies: ["TaxFormatter"]),
    ]
)
