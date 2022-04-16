//
//

enum StateCreditsError : Error {
    case tooManyAutomaticOutOfStateCreditStates
    case unexpectedStateIncome
}

struct StateCredits {

    static func calculateAutomaticStateCredits(existingCredits: [TaxState:Double],
                                               allStateIncomes: [StateIncome],
                                               stateTaxes: [StateTax],
                                               totalIncome: Double,
                                               taxYear:TaxYear,
                                               filingType:FilingType) throws -> [TaxState:Double] {
        var credits = existingCredits

        let eligableStateIncomes = allStateIncomes.filter { income in
            return income.applyOutOfStateIncomeCredits
        }

        guard eligableStateIncomes.count > 0 else { return credits }
        guard eligableStateIncomes.count == 1 else { throw StateCreditsError.tooManyAutomaticOutOfStateCreditStates }

        let eligableStateIncome: StateIncome = eligableStateIncomes.first!

        // sum up other states
        var outOfStateIncome = 0.0
        try stateTaxes.forEach { tax in
            if tax.state != eligableStateIncome.state {
                if tax.incomeRate == 1.0 {
                    throw StateCreditsError.unexpectedStateIncome
                } else {
                    outOfStateIncome += tax.taxableIncome * tax.incomeRate
                }
            }
        }

        if outOfStateIncome > 0.0 {
            let existingTax = stateTaxes.first { tax in
                tax.state == eligableStateIncome.state
            }!
//            let brackets = try TaxBracketFactory.stateTaxBracketFor(eligableStateIncome.state, taxYear: taxYear, filingType: filingType, taxableIncome:totalIncome)
//            let bracket = try TaxBracketFactory.findMatchingBracket(brackets, taxableIncome: totalIncome)
            let credit = existingTax.bracket.calculateTaxesForAmount(outOfStateIncome)

            credits[eligableStateIncome.state] = (credits[eligableStateIncome.state] ?? 0.0) + credit
            print("outOfStateIncome: \(outOfStateIncome), bracket: \(existingTax.bracket), credit: \(credit)")
        }

        return credits
    }
}
