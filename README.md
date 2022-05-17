# USTaxCalculator

A small macOS app (written using Swift & SwiftUI) to calculate US Taxes (federal & state & local level).
You can input income & tax data and then see the resulting taxes and how those were calculated. Compile and run the app locally to use it. You can enter new data or edit and play with the example data found in /Examples/. All example numbers and names are fully fictional.

| Viewing Calculated Taxes | Data Entry |
| ------------- | ------------- |
| ![](https://user-images.githubusercontent.com/807039/168810229-2309ac70-8f3c-44c0-87c0-1e93a717914e.png) | ![](https://user-images.githubusercontent.com/807039/168810242-45bbdade-94e4-49c8-b819-9a65b37e3a21.png) |

## Why?

This started as a small swift script to doublecheck some numbers of my taxes. But I kept tinkering with it to explore Swift & SwiftUI. It now is a macOS app with a UI for entering Income data and vieweing the resulting tax numbers. The code has code comments with links to the sources of all tax rates etc.

## Disclaimers ⚠️ 

This is purely a fun side project, which helped me doublecheck a few calculations.

- This is not tax advice.
- I'm not a CPA, nor a tax consultant.
- Don't blindly trust these numbers.
- This code might miss many details & might contain mistakes.

The code has code comments with links to the sources of all tax rates etc.

## Supported Tax Scenarios

### Tax Years

- 2020
- 2021

### Filing Modes

- Single
- Married jointly

Missing: Married Separately & Head of Household. Married Separately often has the same rates as single though.

### Supported Locations

- Federal Taxes
- State Taxes: CA, NY
- Local Taxes: NYC

### Adding new scenarios

New scenarios can easily be added:

1) Add new cases to the `TaxYear`/`FilingType`/`TaxState`/`TaxCity` enums.
2) Add new taxrates to `RawTaxRates.swift`.
