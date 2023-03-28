//
//

enum ExampleData {
    static func exampleTaxDataJohnAndSarah_21() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            title: "John & Sarah",
            filingType: .marriedJointly,
            taxYear: .y2021,
            income: Income(
                wages: 314000,
                federalWithholdings: 24000,
                medicareWages: 389000,
                medicareWithholdings: 5641,
                dividendsAndInterests: 4500,
                capitalGains: 20000,
                longtermCapitalGains: 16000,
                stateIncomes: [
                    StateIncome(
                        state: .NY,
                        wages: .fullFederal,
                        withholdings: 12000,
                        localTax: .city(.NYC)),
                    StateIncome(
                        state: .CA,
                        wages: .partial(35000),
                        withholdings: 2500),
                ]),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 500,
            stateCredits: [.NY: 3500, .CA: 100]))
    }

    static func exampleTaxDataJackHouston_21() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            title: "Jack Houston",
            filingType: .single,
            taxYear: .y2021,
            income: Income(
                wages: 182000,
                federalWithholdings: 18720,
                medicareWages: 191300,
                medicareWithholdings: 2774,
                dividendsAndInterests: 2500,
                capitalGains: 32190,
                longtermCapitalGains: 23344,
                stateIncomes: [
                    StateIncome(
                        state: .NY,
                        wages: .fullFederal,
                        withholdings: 9800,
                        localTax: .city(.NYC)),
                ]),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 730))
    }

    static func exampleTaxDataJackHouston_20() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            filingType: .single,
            taxYear: .y2020,
            income: Income(
                wages: 133930,
                federalWithholdings: 11227,
                medicareWages: 140626,
                medicareWithholdings: 2039,
                dividendsAndInterests: 3320,
                capitalGains: 42110,
                longtermCapitalGains: 32123,
                stateIncomes: [
                    StateIncome(
                        state: .CA,
                        wages: .fullFederal,
                        withholdings: 4400),
                ]),
            federalDeductions: DeductionAmount.standard(),
            stateCredits: [.CA: 250]))
    }

    static func exampleTaxDataSimple_20() -> CalculatedTaxData {
        return try! CalculatedTaxData(TaxDataInput(
            title: "Simple",
            filingType: .single,
            taxYear: .y2020,
            income: Income(
                wages: 80000,
                federalWithholdings: 3200,
                medicareWages: 82000,
                medicareWithholdings: 1189,
                stateIncomes: [
                    StateIncome(
                        state: .CA,
                        wages: .fullFederal),
                ]),
            federalDeductions: DeductionAmount.standard()))
    }
}
