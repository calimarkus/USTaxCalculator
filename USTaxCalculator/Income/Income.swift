//
//

struct Income {
    /// Wages as listed on W-2, Box 1
    let wages:Double
    /// Medicare Wages as listed on W-2, Box 5
    let medicareWages:Double
    /// Federal Income Tax Withheld as listed on W-2, Box 2
    let federalWithholdings:Double

    /// Any Interests & Dividends (e.g. from Bank Accounts, Investments) as listed on 1099-INT, 1099-DIV
    let dividendsAndInterests:Double
    /// Capital Gains excluding dividends and interests (e.g. from Investments) - as listed on e.g. 1099-B
    let capitalGains:Double
    /// Longterm Gains as listed on e.g. 1099-B (these are taxed lower than shortterm gains)
    let longtermCapitalGains:Double

    /// State Income Information for all states, as listed on W-2
    let stateIncomes:[StateIncome]

    /// Computed combined capital gains (dividends + capital gains)
    var totalCapitalGains: Double { get { return dividendsAndInterests + capitalGains } }
    /// Computed total income (wages + total capital gains)
    var totalIncome: Double { get { return wages + totalCapitalGains } }
}

extension Income {
    static func + (lhs:Income, rhs:Income) throws -> Income {
        return Income(
            wages: lhs.wages + rhs.wages,
            medicareWages: lhs.medicareWages + rhs.medicareWages,
            federalWithholdings: lhs.federalWithholdings + rhs.federalWithholdings,
            dividendsAndInterests: lhs.dividendsAndInterests + rhs.dividendsAndInterests,
            capitalGains: lhs.capitalGains + rhs.capitalGains,
            longtermCapitalGains: lhs.longtermCapitalGains + rhs.longtermCapitalGains,
            stateIncomes: try StateIncome.merge(lhs.stateIncomes, rhs.stateIncomes))
    }
}
