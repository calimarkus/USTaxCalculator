// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaxCalculator",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TaxCalculator",
            targets: ["TaxCalculator"]),
    ],
    dependencies: [
        .package(name: "TaxOutputModels", path: "../TaxOutputModels"),
        .package(name: "TaxInputModels", path: "../TaxInputModels"),
        .package(name: "TaxPrimitives", path: "../TaxPrimitives"),
        .package(name: "TaxRates", path: "../TaxRates")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TaxCalculator",
            dependencies: [
                .product(name: "TaxOutputModels", package: "TaxOutputModels"),
                .product(name: "TaxInputModels", package: "TaxInputModels"),
                .product(name: "TaxPrimitives", package: "TaxPrimitives"),
                .product(name: "TaxRates", package: "TaxRates")
            ]
        ),
        .testTarget(
            name: "TaxCalculatorTests",
            dependencies: ["TaxCalculator"]),
    ]
)
