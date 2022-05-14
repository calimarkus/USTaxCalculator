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
    var outstandingPayment: Double { return taxes - withholdings }
}

extension TaxSummaries {
    static func calculateFor(totalFederalIncome: Double,
                             taxableFederalIncome: Double,
                             federalWithholdings: Double,
                             federalCredits: Double,
                             federalTaxes: [FederalTax],
                             stateTaxes: [StateTax],
                             stateCredits: [TaxState: Double]) -> TaxSummaries
    {
        // sum up federal
        let fedTaxes = federalTaxes.reduce(-federalCredits) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        let federal = TaxSummary(taxes: fedTaxes,
                                 credits: federalCredits,
                                 withholdings: federalWithholdings,
                                 effectiveTaxRate: fedTaxes / totalFederalIncome)

        // sum up states
        var states: [TaxState: TaxSummary] = [:]
        var stateWithholdingsTotal = 0.0, stateCreditsTotal = 0.0, totalStateTaxes = 0.0
        for tax in stateTaxes {
            let credits = stateCredits[tax.state] ?? 0.0
            stateWithholdingsTotal += tax.withholdings
            totalStateTaxes += tax.taxAmount - credits
            stateCreditsTotal += credits

            states[tax.state] = TaxSummary(taxes: tax.taxAmount,
                                           credits: credits,
                                           withholdings: tax.withholdings,
                                           effectiveTaxRate: tax.taxAmount / totalFederalIncome)
        }

        let stateTotal = TaxSummary(taxes: totalStateTaxes,
                                    credits: stateCreditsTotal,
                                    withholdings: stateWithholdingsTotal,
                                    effectiveTaxRate: totalStateTaxes / totalFederalIncome)

        // sum up total
        let total = TaxSummary(taxes: federal.taxes + stateTotal.taxes,
                               credits: federal.credits + stateTotal.credits,
                               withholdings: federal.withholdings + stateTotal.withholdings,
                               effectiveTaxRate: (federal.taxes + stateTotal.taxes) / totalFederalIncome)

        return TaxSummaries(federal: federal, states: states, stateTotal: stateTotal, total: total)
    }
}
