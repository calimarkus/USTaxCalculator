//
//

struct TaxSummaries : Equatable {
    let federal:TaxSummary
    let states:TaxSummary
    let total:TaxSummary
}

struct TaxSummary : Equatable {
    let taxes:Double
    let credits:Double
    let withholdings:Double
    let effectiveTaxRate:Double
    var outstandingPayment:Double { get { return taxes - withholdings } }
}

extension TaxSummaries {
    static func calculateFor(totalFederalIncome: Double,
                             taxableFederalIncome: Double,
                             federalWithholdings: Double,
                             federalCredits: Double,
                             federalTaxes: [FederalTax],
                             stateTaxes: [StateTax],
                             stateCredits: [TaxState: Double]) -> TaxSummaries {
        // sum up federal
        let fedTaxes = federalTaxes.reduce(-federalCredits) { partialResult, tax in
            return partialResult + tax.taxAmount
        }

        let federal = TaxSummary(taxes: fedTaxes,
                                 credits: federalCredits,
                                 withholdings: federalWithholdings,
                                 effectiveTaxRate: fedTaxes / totalFederalIncome)

        // sum up states
        var stateWithholdingsTotal=0.0, stateCreditsTotal=0.0, totalStateTaxes=0.0
        for tax in stateTaxes {
            let credits = stateCredits[tax.state] ?? 0.0
            stateWithholdingsTotal += tax.withholdings
            totalStateTaxes += tax.taxAmount - credits
            stateCreditsTotal += credits
        }

        let states = TaxSummary(taxes: totalStateTaxes,
                                credits: stateCreditsTotal,
                                withholdings: stateWithholdingsTotal,
                                effectiveTaxRate: totalStateTaxes / totalFederalIncome)

        // sum up total
        let total = TaxSummary(taxes: federal.taxes + states.taxes,
                               credits: federal.credits + states.credits,
                               withholdings: federal.withholdings + states.withholdings,
                               effectiveTaxRate: (federal.taxes + states.taxes) / totalFederalIncome)

        return TaxSummaries(federal: federal, states: states, total: total)
    }
}

