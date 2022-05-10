# USTaxCalculator

What started as a small swift script to better understand some numbers of my taxes ended up becoming more and more generic. Thus I figured I clean it up a bit and publish it for anyone to play around with. It now is a mac app with a UI both entering and consuming tax data. The code has code comments with links to the sources of all tax rates etc.

## Disclaimers ⚠️ 

This is purely a fun side project, which helped me doublecheck a few calculations.

- This is not tax advice.
- I'm not a CPA, nor a tax consultant.
- Don't blindly trust these numbers.
- This code might miss many details & might contain mistakes.

## Usage

All example numbers and names are fully fictional and don't represent any real persons.
You can compile and run the app and use it as is to input some data and review it:

<img width="1194" alt="screenshot2" src="https://user-images.githubusercontent.com/807039/167646074-9625bff6-e7f4-41cd-9d30-877f11c3383d.png">

<img width="1291" alt="screenshot1" src="https://user-images.githubusercontent.com/807039/167646098-611e65bb-a99d-41b3-9709-1e9c1dc7729e.png">


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
