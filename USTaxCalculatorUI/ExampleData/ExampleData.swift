//
//

struct ExampleData {

    private static func exampleIncome1() -> Income {
        return Income(
            wages: 220000,
            medicareWages: 248000,
            federalWithholdings: 24000,
            dividendsAndInterests: 4500,
            capitalGains: 20000,
            longtermCapitalGains: 16000,
            stateIncomes: [StateIncome(state: .NY, wages: .fullFederal, withholdings: 12000, localTax: .city(.NYC)),
                           StateIncome(state: .CA, wages: .partial(35000), withholdings: 2500)])
    }

    static func single21Data() -> USTaxData {
        return try! USTaxData(
            title: "John Appleased",
            filingType: .single,
            taxYear: .y2021,
            income: exampleIncome1(),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 500,
            stateCredits: [.NY: 3500])
    }

    private static func exampleIncome2() -> Income {
        return Income(
            wages: 182000,
            medicareWages: 191300,
            federalWithholdings: 18720,
            dividendsAndInterests: 2500,
            capitalGains: 32000,
            longtermCapitalGains: 28000,
            stateIncomes: [StateIncome(state: .NY, wages: .fullFederal, withholdings: 12000, localTax: .city(.NYC)),
                           StateIncome(state: .CA, wages: .partial(35000), withholdings: 2500)])
    }

    static func single20Data() -> USTaxData {
        return try! USTaxData(
            title: "Jacky Dory",
            filingType: .single,
            taxYear: .y2020,
            income: exampleIncome2(),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 500,
            stateCredits: [.NY: 3500])
    }

}
