import Foundation

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
    additionalFederalWithholding: 0,
    stateCredits: 3500,
    federalCredits: 0,
    federalDeductions: DeductionAmount.standard()
)

let formatter = TaxSummaryFormatter(columnWidth: 39,
                                    separatorSize: (width: 26, shift: 16),
                                    printCalculationExplanations: false,
                                    locale:Locale(identifier: "en_US"))
formatter.printTaxDataSummary(exampleTaxData2021)
