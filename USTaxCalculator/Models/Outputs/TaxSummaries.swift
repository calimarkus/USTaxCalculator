//
// TaxSummaries.swift
//

struct TaxSummaries: Equatable {
    let federal: TaxSummary
    let states: [TaxState: TaxSummary]
    let stateTotal: TaxSummary
    var total: TaxSummary { federal + stateTotal }

    init(federal: TaxSummary, states: [TaxState: TaxSummary]) {
        self.federal = federal
        self.states = states
        stateTotal = TaxSummaries.sumStates(states: states)
    }

    private static func sumStates(states: [TaxState: TaxSummary]) -> TaxSummary {
        if let first = states.first {
            // sum up states
            var total = first.value
            for (i, data) in states.enumerated() {
                if i > 0 {
                    total = total + data.value
                }
            }
            return total
        }

        // no state summaries given, fallback on empty summary
        return TaxSummary(taxes: 0.0, withholdings: 0.0, totalIncome: 0.0)
    }
}

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
