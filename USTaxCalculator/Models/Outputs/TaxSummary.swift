//
// TaxSummary.swift
//

struct TaxSummary: Equatable {
    let taxes: Double
    let withholdings: Double

    private var totalIncome: Double
    var effectiveTaxRate: Double { taxes / totalIncome }
    var outstandingPayment: Double { taxes - withholdings }

    init(taxes: Double, withholdings: Double, totalIncome: Double) {
        self.taxes = taxes
        self.withholdings = withholdings
        self.totalIncome = totalIncome
    }

    static func + (lhs: TaxSummary, rhs: TaxSummary) -> TaxSummary {
        precondition(lhs.totalIncome == rhs.totalIncome)
        return TaxSummary(taxes: lhs.taxes + rhs.taxes,
                          withholdings: lhs.withholdings + rhs.withholdings,
                          totalIncome: lhs.totalIncome)
    }
}
