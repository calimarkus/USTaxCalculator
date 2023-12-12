//
// Income.swift
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
    var totalCapitalGains: Double { dividendsAndInterests + capitalGains }
    /// Computed total income (wages + total capital gains)
    var totalIncome: Double { wages + totalCapitalGains }
}

extension Income {
    var namedWages: NamedValue { .init(wages, named: "Wages") }
    var namedMedicareWages: NamedValue { .init(medicareWages, named: "Medicare Wages") }
    var namedCapitalGains: NamedValue { .init(capitalGains, named: "Capital Gains") }
    var namedTotalCapitalGains: NamedValue { .init(totalCapitalGains, named: "Total Capital Gains") }
    var namedLongtermCapitalGains: NamedValue { .init(longtermCapitalGains, named: "Longterm Capital Gains") }
    var namedTotalIncome: NamedValue { .init(totalIncome, named: "Total Income") }
}
