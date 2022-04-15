//
//

struct TaxSummaries {
    let federal:TaxSummary
    let states:TaxSummary
    let total:TaxSummary
}

struct TaxSummary {
    let taxes:Double
    let credits:Double
    let withholdings:Double
    let effectiveTaxRate:Double
    var outstandingPayment:Double { get { return taxes - withholdings } }
}

extension TaxSummaries {
    private static func sumofTaxes(_ taxes: [Tax], credits:Double) -> Double {
        return taxes.reduce(-credits) { partialResult, tax in
            return partialResult + tax.taxAmount
        }
    }

    static func calculateFor(totalFederalIncome: Double,
                             taxableFederalIncome: Double,
                             federalWithholdings: Double,
                             federalCredits: Double,
                             stateCredits: Double,
                             federalTaxes: [FederalTax],
                             stateTaxes: [StateTax]) -> TaxSummaries {

        let fedTaxes = sumofTaxes(federalTaxes, credits: federalCredits)
        let federal = TaxSummary(taxes: fedTaxes,
                                 credits: federalCredits,
                                 withholdings: federalWithholdings,
                                 effectiveTaxRate: fedTaxes / totalFederalIncome)

        // calculate total state withholdings
        let stateWithholdingsTotal = stateTaxes.reduce(0) { partialResult, stateTax in
            return partialResult + stateTax.withholdings
        }

        let stateTaxes = sumofTaxes(stateTaxes, credits: stateCredits)
        let states = TaxSummary(taxes: stateTaxes,
                                credits: stateCredits,
                                withholdings: stateWithholdingsTotal,
                                effectiveTaxRate: stateTaxes / totalFederalIncome)

        let total = TaxSummary(taxes: federal.taxes + states.taxes,
                               credits: federal.credits + states.credits,
                               withholdings: federal.withholdings + states.withholdings,
                               effectiveTaxRate: (federal.taxes + states.taxes) / totalFederalIncome)

        return TaxSummaries(federal: federal, states: states, total: total)
    }
}

