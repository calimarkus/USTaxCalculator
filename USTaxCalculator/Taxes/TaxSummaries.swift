//
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
    var outstandingPayment: Double { return taxes - withholdings }

    static func fromTotalIncome(taxes: Double, withholdings: Double, totalIncome: Double) -> TaxSummary {
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
    static func calculateFor(input: TaxDataInput, federalTaxes: [FederalTax], stateTaxes: [StateTax]) -> TaxSummaries {
        let fedTaxes = federalTaxes.reduce(0.0) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        // federal
        let federal = TaxSummary.fromTotalIncome(
            taxes: fedTaxes - input.federalCredits,
            withholdings: input.income.federalWithholdings + input.additionalFederalWithholding,
            totalIncome: input.income.totalIncome
        )

        // states
        var states: [TaxState: TaxSummary] = [:]
        for tax in stateTaxes {
            states[tax.state] = TaxSummary.fromTotalIncome(
                taxes: tax.taxAmount - (input.stateCredits[tax.state] ?? 0.0),
                withholdings: tax.withholdings,
                totalIncome: input.income.totalIncome
            )
        }

        // state summary
        var stateTotal = TaxSummary(taxes: 0.0, withholdings: 0.0, effectiveTaxRate: 0.0)
        for (_, summary) in states {
            stateTotal = stateTotal + summary
        }

        return TaxSummaries(
            federal: federal,
            states: states,
            stateTotal: stateTotal,
            total: federal + stateTotal
        )
    }
}
