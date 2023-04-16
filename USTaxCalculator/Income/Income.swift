//
//

struct Income: Codable, Equatable {
    /// Wages as listed on W-2, Box 1
    var wages = 0.0
    /// Federal Income Tax Withheld as listed on W-2, Box 2
    var federalWithholdings = 0.0
    /// Medicare Wages as listed on W-2, Box 5
    var medicareWages = 0.0
    /// Medicare Wages as listed on W-2, Box 6
    var medicareWithholdings = 0.0

    /// Any Interests & Dividends (e.g. from Bank Accounts, Investments) as listed on 1099-INT, 1099-DIV
    var dividendsAndInterests = 0.0
    /// Capital Gains excluding dividends and interests (e.g. from Investments) - as listed on e.g. 1099-B
    var capitalGains = 0.0
    /// Longterm Gains as listed on e.g. 1099-B (these are taxed lower than shortterm gains)
    var longtermCapitalGains = 0.0

    /// State Income Information for all states, as listed on W-2
    var stateIncomes: [StateIncome] = []

    /// Computed combined capital gains (dividends + capital gains)
    var totalCapitalGains: Double { return dividendsAndInterests + capitalGains }
    /// Computed total income (wages + total capital gains)
    var totalIncome: Double { return wages + totalCapitalGains }
}

extension Income {
    var namedWages: NamedValue { return NamedValue(amount: wages, name: "Wages") }
    var namedMedicareWages: NamedValue { return NamedValue(amount: medicareWages, name: "Medicare Wages") }
    var namedCapitalGains: NamedValue { return NamedValue(amount: capitalGains, name: "Capital Gains") }
    var namedTotalCapitalGains: NamedValue { return NamedValue(amount: totalCapitalGains, name: "Total Capital Gains") }
    var namedLongtermCapitalGains: NamedValue { return NamedValue(amount: longtermCapitalGains, name: "Longterm Capital Gains") }
}

extension Income {
    static func + (lhs: Income, rhs: Income) throws -> Income {
        return try Income(
            wages: lhs.wages + rhs.wages,
            federalWithholdings: lhs.federalWithholdings + rhs.federalWithholdings,
            medicareWages: lhs.medicareWages + rhs.medicareWages,
            medicareWithholdings: lhs.medicareWithholdings + rhs.medicareWithholdings,
            dividendsAndInterests: lhs.dividendsAndInterests + rhs.dividendsAndInterests,
            capitalGains: lhs.capitalGains + rhs.capitalGains,
            longtermCapitalGains: lhs.longtermCapitalGains + rhs.longtermCapitalGains,
            stateIncomes: StateIncome.merge(lhs.stateIncomes, rhs.stateIncomes)
        )
    }
}
