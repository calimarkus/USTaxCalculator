//
//

struct TaxFactory {
    static func federalTaxesFor(income:Income, taxableFederalIncome:Double, taxYear year:TaxYear, filingType:FilingType) throws -> [FederalTax] {
        var federalTaxes:[FederalTax] = []

        let fed = try TaxBracketFactory.findMatchingBracket(TaxBracketFactory.federalTaxBracketsFor(taxYear: year, filingType: filingType),
                                                            taxableIncome: taxableFederalIncome)
        federalTaxes.append(FederalTax(title: "Income", bracket: fed, taxableIncome: taxableFederalIncome))

        if income.longtermCapitalGains > 0.0 {
            let ltg = try TaxBracketFactory.findMatchingBracket(TaxBracketFactory.federalLongtermGainsBrackets(),
                                                                taxableIncome: taxableFederalIncome)
            federalTaxes.append(FederalTax(title: "Longterm Gains", bracket:ltg, taxableIncome: income.longtermCapitalGains))
        }

        if taxableFederalIncome > TaxBracketFactory.netInvestmentIncomeTaxTaxLimit(filingType: filingType) {
            let nii = try TaxBracketFactory.findMatchingBracket(TaxBracketFactory.netInvestmentIncomeBracketsFor(filingType: filingType),
                                                                taxableIncome: taxableFederalIncome)
            federalTaxes.append(FederalTax(title: "NII", bracket:nii, taxableIncome: income.totalCapitalGains))
        }

        if taxableFederalIncome > TaxBracketFactory.additionalMedicareTaxThreshhold(filingType: filingType) {
            let medi = try TaxBracketFactory.findMatchingBracket(TaxBracketFactory.additionalMedicareBracketsFor(filingType: filingType),
                                                                 taxableIncome: taxableFederalIncome)
            federalTaxes.append(FederalTax(title: "Medicare", bracket:medi, taxableIncome: income.medicareWages))
        }

        return federalTaxes
    }

    static func stateTaxFor(stateIncome:StateIncome, totalIncome:Double, taxYear year:TaxYear, filingType:FilingType) throws -> StateTax {
        let deductions = DeductionAmount.stateAmount(amount: stateIncome.deductions,
                                                     taxYear: year,
                                                     state: stateIncome.state,
                                                     filingType: filingType)
        let taxableIncome = totalIncome + stateIncome.additionalStateIncome - deductions

        let brackets = try TaxBracketFactory.stateTaxBracketFor(stateIncome.state, taxYear: year, filingType: filingType, taxableIncome:taxableIncome)
        let bracket = try TaxBracketFactory.findMatchingBracket(brackets, taxableIncome: taxableIncome)

        return StateTax(state:stateIncome.state,
                        bracket: bracket,
                        taxableIncome: taxableIncome,
                        deductions: deductions,
                        withholdings: stateIncome.withholdings,
                        incomeRate: stateIncome.incomeRateFor(federalIncome: totalIncome))
    }
}
