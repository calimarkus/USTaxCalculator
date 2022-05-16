//
//

struct TaxSummaries: Equatable {
    let federal: TaxSummary
    let states: [TaxState: TaxSummary]
    let stateTotal: TaxSummary
    let total: TaxSummary

    init(federal: TaxSummary, states: [TaxState: TaxSummary]) {
        self.federal = federal
        self.states = states

        // state summary
        var stateTotal = TaxSummary(taxes: 0.0, withholdings: 0.0, effectiveTaxRate: 0.0)
        for (_, summary) in states {
            stateTotal = stateTotal + summary
        }
        self.stateTotal = stateTotal

        // total summary
        self.total = federal + stateTotal
    }
}

struct TaxSummary: Equatable {
    let taxes: Double
    let withholdings: Double
    let effectiveTaxRate: Double
    var outstandingPayment: Double { return taxes - withholdings }

    static func fromTotalIncome(taxes: Double,
                                withholdings: Double,
                                totalIncome: Double) -> TaxSummary
    {
        TaxSummary(taxes: taxes,
                   withholdings: withholdings,
                   effectiveTaxRate: taxes / totalIncome)
    }

    static func +(lhs: TaxSummary, rhs: TaxSummary) -> TaxSummary {
        return TaxSummary(taxes: lhs.taxes + rhs.taxes,
                          withholdings: lhs.withholdings + rhs.withholdings,
                          effectiveTaxRate: lhs.effectiveTaxRate + rhs.effectiveTaxRate)
    }
}

extension TaxSummaries {
    static func calculateFor(input: TaxDataInput,
                             federalTaxes: [FederalTax],
                             stateTaxes: [StateTax]) -> TaxSummaries
    {
        let fedTaxes = federalTaxes.reduce(0.0) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        let federal = TaxSummary.fromTotalIncome(taxes: fedTaxes - input.federalCredits,
                                                 withholdings: input.income.federalWithholdings + input.additionalFederalWithholding,
                                                 totalIncome: input.income.totalIncome)

        var states: [TaxState: TaxSummary] = [:]
        for tax in stateTaxes {
            let credits = input.stateCredits[tax.state] ?? 0.0
            let summary = TaxSummary.fromTotalIncome(taxes: tax.taxAmount - credits,
                                                     withholdings: tax.withholdings,
                                                     totalIncome: input.income.totalIncome)
            states[tax.state] = summary
        }

        return TaxSummaries(federal: federal, states: states)
    }
}
