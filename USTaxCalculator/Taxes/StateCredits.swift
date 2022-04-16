//
//

enum StateCreditsError : Error {
    case tooManyAutomaticOutOfStateCreditStates
    case unexpectedStateIncome
}

struct StateCredits {

    static func calculateAutomaticStateCredits(existingCredits: [TaxState:Double],
                                               allStateIncomes: [StateIncome],
                                               taxYear:TaxYear,
                                               filingType:FilingType) throws -> [TaxState:Double] {
        var credits = existingCredits

        let eligableStateIncomes = allStateIncomes.filter { tax in
            return tax.applyOutOfStateIncomeCredits
        }

        guard eligableStateIncomes.count > 0 else { return credits }
        guard eligableStateIncomes.count == 1 else { throw StateCreditsError.tooManyAutomaticOutOfStateCreditStates }

        let eligableStateIncome: StateIncome = eligableStateIncomes.first!

        // sum up other states
        var outOfStateIncome = 0.0
        try allStateIncomes.forEach { income in
            if income.state != eligableStateIncome.state {
                switch income.wages {
                    case IncomeAmount.fullFederal:
                        throw StateCreditsError.unexpectedStateIncome
                    case let IncomeAmount.partial(amount):
                        outOfStateIncome += amount + income.additionalStateIncome
                }
            }
        }

        if outOfStateIncome > 0.0 {
            let brackets = try TaxBracketFactory.stateTaxBracketFor(eligableStateIncome.state, taxYear: taxYear, filingType: filingType, taxableIncome:outOfStateIncome)
            let bracket = try TaxBracketFactory.findMatchingBracket(brackets, taxableIncome: outOfStateIncome)
            let credit = bracket.calculateTaxesForAmount(outOfStateIncome)

            credits[eligableStateIncome.state] = (credits[eligableStateIncome.state] ?? 0.0) + credit
            print("outOfStateIncome: \(outOfStateIncome), bracket: \(bracket), credit: \(credit)")
        }

        return credits
    }
}
