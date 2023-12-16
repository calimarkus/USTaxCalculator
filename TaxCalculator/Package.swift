// swift-tools-version:5.7
// (minimum version of Swift required to build this package)

import PackageDescription

let package = Package(
  name: "TaxCalculator",
  products: [
    .library(
      name: "TaxCalculator",
      targets: [
        "TaxRates",
        "TaxPrimitives",
        "TaxInputModels",
        "TaxOutputModels",
        "TaxFormatter",
        "TaxCalculator"
      ]
    ),
  ],
  targets: [
    .target(name: "TaxRates", path: "TaxRates"),
    .target(name: "TaxPrimitives", path: "TaxPrimitives"),
    .target(name: "TaxInputModels", path: "TaxInputModels"),
    .target(name: "TaxOutputModels", path: "TaxOutputModels"),
    .target(name: "TaxFormatter", path: "TaxFormatter"),
    .target(name: "TaxCalculator", path: "TaxCalculator"),
  ]
)
