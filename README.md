# USTaxCalculator

What started as a small swift script to better understand some numbers of my taxes ended up becoming more and more flexible and generic. Thus I figured I clean it up a bit and publish it for anyone to play around with. The code contains links to the sources of all tax rates etc. in code comments.

## Disclaimers ⚠️ 

- This is not tax advice.
- I'm not a CPA, nor a tax consultant.
- Don't blindly trust these numbers.
- This code might miss many details & might contain mistakes.

This is purely a fun side project, which helped me doublecheck a few calculations.

## Supported Scenarios

### Filing Modes

- Single
- Married jointly

Married Separately & Head of Household not supported.
This can easily be extended. See `RawTaxRates.swift`

### Locations

- Federal Taxes
- CA
- NY & NYC

This can easily be extended. See `RawTaxRates.swift`

### Tax Years

- 2020
- 2021

This can easily be extended. See `RawTaxRates.swift`

## Usage Example (see `main.swift`)

All example numbers are fully fictional and don't represent anything real.

This Input:

```swift
let exampleIncome21 = Income(
    wages: 220000,
    medicareWages: 248000,
    federalWithholdings: 24000,
    dividendsAndInterests: 4500,
    capitalGains: 20000,
    longtermCapitalGains: 16000,
    stateIncomes: [StateIncome(state: .NY, wages: .fullFederal, withholdings: 12000, localTax: .city(.NYC)),
                   StateIncome(state: .CA, wages: .partial(35000), withholdings: 2500)])

let exampleTaxData2021 = try USTaxData(
    title: "Fictional Example",
    filingType: .single,
    taxYear: .y2021,
    income: exampleIncome21,
    federalDeductions: DeductionAmount.standard(),
    federalCredits: 500,
    stateCredits: [.NY: 3500]
)
```

will give you a formatted overview of your tax numbers, like so:

```markdown
FICTIONAL EXAMPLE - YEAR 2021 (SINGLE, NY+CA)
=============================================

FED TAXES:
- Wages:                       $220,000 
                                $24,500 (capital gains)
- Total Income:                $244,500 
                               -$16,000 (longterm gains)
                               -$12,550 (deductions)
- Taxable Income:              $215,950 

- Taxes:
  - Federal Credits:              -$500 
  - Income Tax:                 $50,127 
    Rate:                          35.0% ($210K+)
  - Longterm Gains Tax:          $2,400 
    Rate:                          15.0% ($81K+)
  - NII Tax:                       $931 
    Rate:                           3.8% ($200K+)
  - Medicare Tax:                  $432 
    Rate:                           0.9% ($200K+)
                             -------------------------- 
- Total tax:                    $53,390 
                               -$24,000 (withheld)
- To Pay (Fed):                 $29,390 
  ->                               21.8% (effective)

STATE TAXES:
- NY (at 100.0%)
  Deductions:                   -$8,000 
  Taxable Income:              $236,500 
  - State Credits:              -$3,500 
  - State Tax:                  $16,201 
    Rate:                           6.9% ($216K+)
  - Local Tax (NYC):             $9,042 
    Local Rate:                     3.9% ($50K+)
  - Total:                      $21,743 
                               -$12,000 (withheld)
  To Pay:                        $9,743 
- CA (at 14.3%)
  Deductions:                   -$4,803 
  Taxable Income:              $239,697 
  - State Tax:                   $2,762 
    Rate:                           9.3% ($62K+)
                                -$2,500 (withheld)
  To Pay:                          $262 
                             -------------------------- 
- Total tax:                    $24,505 
                               -$14,500 (withheld)
- To Pay (State Total):         $10,005 
  ->                               10.0% (effective)

SUMMARY:
- Income:                      $244,500 
- Total tax:                    $77,894 
                               -$38,500 (withheld)
- To Pay (Total):               $39,394 
  ->                               31.9% (effective)
```
