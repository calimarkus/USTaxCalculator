//
//

struct ExampleData {

    private static func exampleIncome() -> Income {
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
            title: "Fictional Example",
            filingType: .single,
            taxYear: .y2021,
            income: exampleIncome(),
            federalDeductions: DeductionAmount.standard(),
            federalCredits: 500,
            stateCredits: [.NY: 3500])
    }

}
