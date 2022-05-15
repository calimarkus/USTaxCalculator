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
    let credits: Double
    let withholdings: Double
    let effectiveTaxRate: Double
    var outstandingPayment: Double { return taxes - credits - withholdings }

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

        let federal = TaxSummary(taxes: fedTaxes,
                                 credits: input.federalCredits,
                                 withholdings: input.income.federalWithholdings + input.additionalFederalWithholding,
                                 effectiveTaxRate: fedTaxes / input.income.totalIncome)

        // sum up states
        var stateTotal = TaxSummary(taxes: 0.0, credits: 0.0, withholdings: 0.0, effectiveTaxRate: 0.0)
        var states: [TaxState: TaxSummary] = [:]
        for tax in stateTaxes {
            let summary = TaxSummary(taxes: tax.taxAmount,
                                     credits: stateCredits[tax.state] ?? 0.0,
                                     withholdings: tax.withholdings,
                                     effectiveTaxRate: tax.taxAmount / input.income.totalIncome)

            stateTotal = stateTotal + summary
            states[tax.state] = summary
        }

        // sum up total
        let total = TaxSummary(taxes: federal.taxes + stateTotal.taxes,
                               credits: federal.credits + stateTotal.credits,
                               withholdings: federal.withholdings + stateTotal.withholdings,
                               effectiveTaxRate: (federal.taxes + stateTotal.taxes) / input.income.totalIncome)

        return TaxSummaries(federal: federal, states: states, stateTotal: stateTotal, total: total)
    }
}
