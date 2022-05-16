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
        var stateTotal = TaxSummary(taxes: 0.0, credits: 0.0, withholdings: 0.0, effectiveTaxRate: 0.0)
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
    let credits: Double
    let withholdings: Double
    let effectiveTaxRate: Double
    var outstandingPayment: Double { return taxes - credits - withholdings }

    static func fromTotalIncome(taxes: Double,
                                credits: Double,
                                withholdings: Double,
                                totalIncome: Double) -> TaxSummary
    {
        TaxSummary(taxes: taxes,
                   credits: credits,
                   withholdings: withholdings,
                   effectiveTaxRate: (taxes - credits) / totalIncome)
    }

    static func +(lhs: TaxSummary, rhs: TaxSummary) -> TaxSummary {
        return TaxSummary(taxes: lhs.taxes + rhs.taxes,
                          credits: lhs.credits + rhs.credits,
                          withholdings: lhs.withholdings + rhs.withholdings,
                          effectiveTaxRate: lhs.effectiveTaxRate + rhs.effectiveTaxRate)
    }
}

extension TaxSummaries {
    static func calculateFor(input: TaxDataInput,
                             federalTaxes: [FederalTax],
                             stateTaxes: [StateTax],
                             stateCredits: [TaxState: Double]) -> TaxSummaries
    {
        let fedTaxes = federalTaxes.reduce(0.0) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        let federal = TaxSummary.fromTotalIncome(taxes: fedTaxes,
                                                 credits: input.federalCredits,
                                                 withholdings: input.income.federalWithholdings + input.additionalFederalWithholding,
                                                 totalIncome: input.income.totalIncome)

        var states: [TaxState: TaxSummary] = [:]
        for tax in stateTaxes {
            let summary = TaxSummary.fromTotalIncome(taxes: tax.taxAmount,
                                                     credits: stateCredits[tax.state] ?? 0.0,
                                                     withholdings: tax.withholdings,
                                                     totalIncome: input.income.totalIncome)
            states[tax.state] = summary
        }

        return TaxSummaries(federal: federal, states: states)
    }
}
