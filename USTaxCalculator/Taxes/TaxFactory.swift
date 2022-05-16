//
//

enum TaxFactory {
    static func federalTaxesFor(income: Income, taxableFederalIncome: Double, taxYear year: TaxYear, filingType: FilingType) throws -> [FederalTax] {
        var federalTaxes: [FederalTax] = []

        let fed = try TaxBracketFactory.federalTaxBracketsFor(taxYear: year, filingType: filingType).matchingBracketFor(taxableIncome: taxableFederalIncome)
        federalTaxes.append(FederalTax(title: "Income", bracket: fed, taxableIncome: taxableFederalIncome))

        if income.longtermCapitalGains > 0.0 {
            let ltg = try TaxBracketFactory.federalLongtermGainsBrackets().matchingBracketFor(taxableIncome: taxableFederalIncome)
            federalTaxes.append(FederalTax(title: "Longterm Gains", bracket: ltg, taxableIncome: income.longtermCapitalGains))
        }

        if taxableFederalIncome > TaxBracketFactory.netInvestmentIncomeTaxTaxLimit(filingType: filingType) {
            let nii = try TaxBracketFactory.netInvestmentIncomeBracketsFor(filingType: filingType).matchingBracketFor(taxableIncome: taxableFederalIncome)
            federalTaxes.append(FederalTax(title: "Net Investment Income", bracket: nii, taxableIncome: income.totalCapitalGains))
        }

        if income.medicareWages > TaxBracketFactory.additionalMedicareTaxThreshhold(filingType: filingType) {
            let medi = try TaxBracketFactory.additionalMedicareBracketsFor(filingType: filingType).matchingBracketFor(taxableIncome: income.medicareWages)
            federalTaxes.append(FederalTax(title: "Medicare", bracket: medi, taxableIncome: income.medicareWages))
        }

        return federalTaxes
    }

    static func localTaxBracketForLocalTax(_ localTax: LocalTaxType, taxableIncome: Double, taxYear year: TaxYear, filingType: FilingType) throws -> LocalTax? {
        switch localTax {
            case .none:
                return nil
            case let .city(city):
                let brackets = try TaxBracketFactory.cityTaxBracketFor(city, taxYear: year, filingType: filingType, taxableIncome: taxableIncome)
                let bracket = try brackets.matchingBracketFor(taxableIncome: taxableIncome)
                return LocalTax(city: city, bracket: bracket, taxableIncome: taxableIncome)
        }
    }

    static func stateTaxFor(stateIncome: StateIncome,
                            stateDeductions: [TaxState: DeductionAmount],
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
        let bracket = try brackets.matchingBracketFor(taxableIncome: taxableIncome)

        let localTax = try localTaxBracketForLocalTax(stateIncome.localTax, taxableIncome: taxableIncome, taxYear: year, filingType: filingType)

        return StateTax(state: stateIncome.state,
                        bracket: bracket,
                        localTax: localTax, taxableIncome: taxableIncome,
                        additionalStateIncome: stateIncome.additionalStateIncome,
                        deductions: deductions,
                        withholdings: stateIncome.withholdings,
                        incomeRate: stateIncome.incomeRateGivenFederalIncome(totalIncome),
                        stateAttributedIncome: stateIncome.attributableIncomeGivenFederalIncome(totalIncome))
    }
}
