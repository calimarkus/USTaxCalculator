//
//

enum TaxFactory {
    static func federalTaxesFor(income: Income, taxableFederalIncome: NamedValue, taxRates: FederalTaxRates) throws -> [FederalTax] {
        var federalTaxes: [FederalTax] = []

        // income tax
        let incomeBracketGroup = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.incomeRates)
        let incomeBracket = incomeBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome.amount)
        federalTaxes.append(FederalTax(title: "Income", bracket: incomeBracket, bracketGroup: incomeBracketGroup, taxableIncome: taxableFederalIncome))

        // longterm gains tax
        let longtermGainBracketGroup = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.longtermGainsRates)
        let longtermGainsBracket = longtermGainBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome.amount)
        if longtermGainsBracket.rate > 0.0 {
            federalTaxes.append(FederalTax(title: "Longterm Gains",
                                           bracket: longtermGainsBracket,
                                           bracketGroup: longtermGainBracketGroup,
                                           taxableIncome: income.namedLongtermCapitalGains))
        }

        // net investment income tax
        let niiBracketGroup = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.netInvestmentIncomeRates)
        let niiBracket = niiBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome.amount)
        if niiBracket.rate > 0.0 {
            let taxableRegularIncome = taxableFederalIncome.amount - niiBracket.startingAt
            let taxableNIIIncome = (income.totalCapitalGains < taxableRegularIncome
                ? income.namedTotalCapitalGains
                : NamedValue(amount: taxableRegularIncome, name: "Taxable Income for NII"))
            federalTaxes.append(FederalTax(title: "Net Investment Income",
                                           bracket: niiBracket,
                                           bracketGroup: niiBracketGroup,
                                           taxableIncome: taxableNIIIncome))
        }

        // additional medicare tax
        let medicareBracketGroup = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.additionalMedicareIncomeRates)
        let medicareBracket = medicareBracketGroup.matchingBracketFor(taxableIncome: income.medicareWages)
        if medicareBracket.rate > 0.0 {
            let basicBracketGroup = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.basicMedicareIncomeRates)
            let basicBracket = basicBracketGroup.matchingBracketFor(taxableIncome: income.medicareWages)
            let expectedBasicWithholding = income.medicareWages * basicBracket.rate
            let tax = FederalTax(title: "Additional Medicare",
                                 bracket: medicareBracket,
                                 bracketGroup: medicareBracketGroup,
                                 taxableIncome: income.namedMedicareWages)
            let expectedTotalWithholding = expectedBasicWithholding + tax.taxAmount

            // only apply additional medicare tax, if not already withheld
            if income.medicareWithholdings < expectedTotalWithholding {
                federalTaxes.append(tax)
            }
        }

        return federalTaxes
    }

    static func stateTaxFor(stateIncome: StateIncome,
                            stateDeductions: [TaxState: DeductionAmount],
                            stateCredits: [TaxState: Double],
                            totalIncome: Double,
                            taxRates: RawTaxRatesYear) throws -> StateTax
    {
        let deductions = try DeductionsFactory.calculateStateDeductions(for: stateIncome.state, stateDeductions: stateDeductions, taxRates: taxRates)
        let taxableIncome = max(0.0, totalIncome + stateIncome.additionalStateIncome - deductions)
        let namedTaxableIncome = NamedValue(amount: taxableIncome, name: "Taxable State Income")

        let brackets = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.stateIncomeRatesForState(stateIncome.state, taxableIncome: taxableIncome))
        let bracket = brackets.matchingBracketFor(taxableIncome: taxableIncome)

        let localTax = try localTaxBracketForLocalTax(stateIncome.localTax,
                                                      taxableIncome: namedTaxableIncome,
                                                      taxRates: taxRates)

        return StateTax(state: stateIncome.state,
                        bracket: bracket,
                        bracketGroup: brackets,
                        localTax: localTax,
                        taxableIncome: namedTaxableIncome,
                        additionalStateIncome: stateIncome.additionalStateIncome,
                        deductions: deductions,
                        withholdings: stateIncome.withholdings,
                        credits: stateCredits[stateIncome.state] ?? 0.0,
                        incomeRate: stateIncome.incomeRateGivenFederalIncome(totalIncome),
                        stateAttributedIncome: stateIncome.attributableIncomeGivenFederalIncome(totalIncome))
    }

    static func localTaxBracketForLocalTax(_ localTax: LocalTaxType, taxableIncome: NamedValue, taxRates: RawTaxRatesYear) throws -> LocalTax? {
        switch localTax {
            case .none:
                return nil
            case let .city(city):
                let brackets = try TaxBracketGenerator.bracketsForRawTaxRates(taxRates.localIncomeRatesForCity(city, taxableIncome: taxableIncome.amount))
                let bracket = brackets.matchingBracketFor(taxableIncome: taxableIncome.amount)

                return LocalTax(
                    city: city,
                    bracket: bracket,
                    bracketGroup: brackets,
                    taxableIncome: taxableIncome
                )
        }
    }
}
