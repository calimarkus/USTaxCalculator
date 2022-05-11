//
//

enum ExampleData {
    private static func exampleIncomeA_NY_CA() -> Income {
        return Income(
            wages: 314000,
            medicareWages: 248000,
            federalWithholdings: 24000,
            dividendsAndInterests: 4500,
            capitalGains: 20000,
            longtermCapitalGains: 16000,
            stateIncomes: [StateIncome(state: .NY, wages: .fullFederal, withholdings: 12000, localTax: .city(.NYC)),
                           StateIncome(state: .CA, wages: .partial(35000), withholdings: 2500)])
    }

    static func exampleTaxDataJohnAndSarah_21() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            title: "John & Sarah",
            filingType: .marriedJointly,
            taxYear: .y2021,
            income: exampleIncomeA_NY_CA(),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 500,
            stateCredits: [.NY: 3500]))
    }

    private static func exampleIncomeB_NY() -> Income {
        return Income(
            wages: 182000,
            medicareWages: 191300,
            federalWithholdings: 18720,
            dividendsAndInterests: 2500,
            capitalGains: 32190,
            longtermCapitalGains: 23344,
            stateIncomes: [StateIncome(state: .NY, wages: .fullFederal, withholdings: 9800, localTax: .city(.NYC))])
    }

    static func exampleTaxDataJackHouston_21() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            title: "Jack Houston",
            filingType: .single,
            taxYear: .y2021,
            income: exampleIncomeB_NY(),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 730))
    }

    private static func exampleIncomeC_CA() -> Income {
        return Income(
            wages: 133930,
            medicareWages: 140626,
            federalWithholdings: 11227,
            dividendsAndInterests: 3320,
            capitalGains: 42110,
            longtermCapitalGains: 32123,
            stateIncomes: [StateIncome(state: .CA, wages: .fullFederal, withholdings: 4400)])
    }

    static func exampleTaxDataJackHouston_20() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            filingType: .single,
            taxYear: .y2020,
            income: exampleIncomeC_CA(),
            federalDeductions: DeductionAmount.standard(),
            stateCredits: [.CA: 250]))
    }
}
