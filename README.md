# USTaxCalculator
### Supporting years '20-'22, Federal + CA + NY + NYC

A small universal macOS & iOS app (written using Swift & SwiftUI) to calculate US Taxes (federal & state & local level).
You can input income & tax data and then see the resulting taxes and how those were calculated. Compile and run the app locally to use it. You can enter new data or edit and play with the example data found in `/Examples/`. All example numbers and names are fully fictional. The macOS app is document-based, whereas the iOS one currently is purely memory based (no persistence).

| Viewing Calculated Taxes (macOS) | Data Entry (macOS) |
| ------------- | ------------- |
| ![](https://user-images.githubusercontent.com/807039/169698179-24749e27-4ef1-42fb-a93c-6caf03e4677b.png) | ![](https://user-images.githubusercontent.com/807039/169698185-cd8c1c30-2d33-48a4-8d6d-155c829e1d1e.png) |

| Viewing Calculated Taxes (iOS) | Details | Data Entry (iOS) |
| ------------- | ------------- | ------------- |
| ![](https://user-images.githubusercontent.com/807039/169698222-98505e06-b57b-455f-9507-ce64bccc1962.png) | ![](https://user-images.githubusercontent.com/807039/169698223-aad7af63-bb75-401d-a620-8ba03c855020.png) | ![](https://user-images.githubusercontent.com/807039/169698225-29eae43c-69a1-4e88-be8a-5f8abc1e109b.png) |


## Why?

This started as a small swift script to doublecheck some numbers of my taxes. But I kept tinkering with it to explore Swift & SwiftUI more. Now it's is a universal macOS/iOS app with a UI to enter & consume tax data.

## Disclaimers ⚠️ 

This is purely a fun side project, which helped me doublecheck a few calculations.

- This is not tax advice.
- I'm not a CPA, nor a tax consultant.
- Don't blindly trust these numbers.
- This code might miss many details & might contain mistakes.

The code has code comments with links to the sources of all tax rates etc.

## Supported Tax Scenarios

### Tax Years

- 2020 through 2022

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
2) Add new taxrates to `USTaxCalculator/RawTaxRates/*.swift`.
