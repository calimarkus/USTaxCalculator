//
//

enum TaxFactory {
    static func federalTaxesFor(income: Income, taxableFederalIncome: Double, taxYear year: TaxYear, filingType: FilingType) throws -> [FederalTax] {
        var federalTaxes: [FederalTax] = []

        // income tax
        let incomeBracketGroup = try TaxBracketFactory.federalTaxBracketsFor(taxYear: year, filingType: filingType)
        let incomeBracket = incomeBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        federalTaxes.append(FederalTax(title: "Income", bracket: incomeBracket, bracketGroup: incomeBracketGroup, taxableIncome: taxableFederalIncome))

        // longterm gains tax
        let longtermGainBracketGroup = try TaxBracketFactory.federalLongtermGainsBrackets(taxYear: year, filingType: filingType)
        let longtermGainsBracket = longtermGainBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        if longtermGainsBracket.rate > 0.0 {
            federalTaxes.append(FederalTax(title: "Longterm Gains",
                                           bracket: longtermGainsBracket,
                                           bracketGroup: longtermGainBracketGroup,
                                           taxableIncome: income.longtermCapitalGains))
        }

        // net investment income tax
        let niiBracketGroup = TaxBracketFactory.netInvestmentIncomeBracketsFor(filingType: filingType)
        let niiBracket = niiBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        if niiBracket.rate > 0.0 {
            federalTaxes.append(FederalTax(title: "Net Investment Income",
                                           bracket: niiBracket,
                                           bracketGroup: niiBracketGroup,
                                           taxableIncome: income.totalCapitalGains))
        }

        // additional medicare tax
        let medicareBracketGroup = TaxBracketFactory.additionalMedicareBracketsFor(filingType: filingType)
        let medicarBracket = medicareBracketGroup.matchingBracketFor(taxableIncome: income.medicareWages)
        if medicarBracket.rate > 0.0 {
            federalTaxes.append(FederalTax(title: "Additional Medicare",
                                           bracket: medicarBracket,
                                           bracketGroup: medicareBracketGroup,
                                           taxableIncome: income.medicareWages))
        }

        return federalTaxes
    }

    static func localTaxBracketForLocalTax(_ localTax: LocalTaxType, taxableIncome: Double, taxYear year: TaxYear, filingType: FilingType) throws -> LocalTax? {
        switch localTax {
            case .none:
                return nil
            case let .city(city):
                let brackets = try TaxBracketFactory.cityTaxBracketFor(city, taxYear: year, filingType: filingType, taxableIncome: taxableIncome)
                let bracket = brackets.matchingBracketFor(taxableIncome: taxableIncome)
                return LocalTax(city: city, bracket: bracket, bracketGroup: brackets, taxableIncome: taxableIncome)
        }
    }

    static func stateTaxFor(stateIncome: StateIncome,
                            stateDeductions: [TaxState: DeductionAmount],
                            stateCredits: [TaxState: Double],
                            totalIncome: Double,
                            taxYear year: TaxYear,
                            filingType: FilingType) throws -> StateTax
    {
        let deductionAmount = stateDeductions[stateIncome.state] ?? DeductionAmount.standard()
        let deductions = DeductionAmount.stateAmount(deductionAmount,
                                                     taxYear: year,
                                                     state: stateIncome.state,
                                                     filingType: filingType)
        let taxableIncome = max(0.0, totalIncome + stateIncome.additionalStateIncome - deductions)

        let brackets = try TaxBracketFactory.stateTaxBracketFor(stateIncome.state, taxYear: year, filingType: filingType, taxableIncome: taxableIncome)
        let bracket = brackets.matchingBracketFor(taxableIncome: taxableIncome)

        let localTax = try localTaxBracketForLocalTax(stateIncome.localTax, taxableIncome: taxableIncome, taxYear: year, filingType: filingType)

        return StateTax(state: stateIncome.state,
                        bracket: bracket,
                        bracketGroup: brackets,
                        localTax: localTax, taxableIncome: taxableIncome,
                        additionalStateIncome: stateIncome.additionalStateIncome,
                        deductions: deductions,
                        withholdings: stateIncome.withholdings,
                        credits: stateCredits[stateIncome.state] ?? 0.0,
                        incomeRate: stateIncome.incomeRateGivenFederalIncome(totalIncome),
                        stateAttributedIncome: stateIncome.attributableIncomeGivenFederalIncome(totalIncome))
    }
}
