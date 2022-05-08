# USTaxCalculator

What started as a small swift script to better understand some numbers of my taxes ended up becoming more and more flexible and generic. Thus I figured I clean it up a bit and publish it for anyone to play around with. The code contains links to the sources of all tax rates etc. in code comments.

## Disclaimers ⚠️ 

This is purely a fun side project, which helped me doublecheck a few calculations.

- This is not tax advice.
- I'm not a CPA, nor a tax consultant.
- Don't blindly trust these numbers.
- This code might miss many details & might contain mistakes.

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

## Usage Example (see `TaxDataView.swift`)

All numbers & names are fully fictional examples & don't represent any real persons.

This Input:

```swift
let exampleIncome21 = Income(
    wages: 314000,
    medicareWages: 248000,
    federalWithholdings: 24000,
    dividendsAndInterests: 4500,
    capitalGains: 20000,
    longtermCapitalGains: 16000,
    stateIncomes: [StateIncome(state: .NY, wages: .fullFederal, withholdings: 12000, localTax: .city(.NYC)),
                   StateIncome(state: .CA, wages: .partial(35000), withholdings: 2500)]
)

let exampleTaxData2021 = try USTaxData(
    title: "John & Sarah",
    filingType: .marriedJointly,
    taxYear: .y2021,
    income: exampleIncome21,
    federalDeductions: DeductionAmount.standard(),
    federalCredits: 500,
    stateCredits: [.NY: 3500]
)
```

will be displayed like so:

<img width="1088" alt="screenshot" src="https://user-images.githubusercontent.com/807039/167285855-40f1645c-d45a-44dd-9a59-28d6c621804f.png">


