//
// TaxSummary.swift
//

struct TaxSummary: Equatable {
    let taxes: Double
    let withholdings: Double

    private var totalIncome: Double
    var effectiveTaxRate: Double { totalIncome > 0.0 ? taxes / totalIncome : 0.0 }
    var outstandingPayment: Double { taxes - withholdings }

    init(taxes: Double, withholdings: Double, totalIncome: Double) {
        self.taxes = taxes
        self.withholdings = withholdings
        self.totalIncome = totalIncome
    }

    static func + (lhs: TaxSummary, rhs: TaxSummary) -> TaxSummary {
        guard lhs.taxes > 0.0, lhs.totalIncome > 0.0 else {
            return rhs
        }
        precondition(lhs.totalIncome == rhs.totalIncome)
        return TaxSummary(taxes: lhs.taxes + rhs.taxes,
                          withholdings: lhs.withholdings + rhs.withholdings,
                          totalIncome: lhs.totalIncome)
    }
}
