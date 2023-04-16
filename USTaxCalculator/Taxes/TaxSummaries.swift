//
// TaxSummaries.swift
//

struct TaxSummaries: Equatable {
    let federal: TaxSummary
    let states: [TaxState: TaxSummary]
    let stateTotal: TaxSummary
    let total: TaxSummary
}

struct TaxSummary: Equatable {
    let taxes: Double
    let withholdings: Double
    let effectiveTaxRate: Double
    var outstandingPayment: Double { taxes - withholdings }

    static func fromTotalIncome(taxes: Double, withholdings: Double, totalIncome: Double) -> TaxSummary {
        TaxSummary(taxes: taxes,
                   withholdings: withholdings,
                   effectiveTaxRate: taxes / totalIncome)
    }

    static func + (lhs: TaxSummary, rhs: TaxSummary) -> TaxSummary {
        TaxSummary(taxes: lhs.taxes + rhs.taxes,
                   withholdings: lhs.withholdings + rhs.withholdings,
                   effectiveTaxRate: lhs.effectiveTaxRate + rhs.effectiveTaxRate)
    }
}
