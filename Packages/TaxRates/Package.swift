// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaxRates",
    products: [
        .library(
            name: "TaxRates",
            targets: ["TaxRates"]),
    ],
    targets: [
        .target(
            name: "TaxRates"),
        .testTarget(
            name: "TaxRatesTests",
            dependencies: ["TaxRates"]),
    ]
)
