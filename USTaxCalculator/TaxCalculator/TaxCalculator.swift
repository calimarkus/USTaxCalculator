//
// TaxCalculator.swift
//

enum TaxCalculator {
    static func calculateTaxesForInput(_ input: TaxDataInput) -> CalculatedTaxData {
        let taxRates = RawTaxRatesYear.taxRatesYearFor(input.taxYear, input.filingType)

        let federalData = Self.federalTaxesFor(
            income: input.income,
            federalDeductions: input.federalDeductions,
            federalCredits: input.federalCredits,
            federalRates: taxRates.federalRates
        )

        let stateTaxes = input.income.stateIncomes.map { stateIncome in
            Self.stateTaxFor(
                stateIncome: stateIncome,
                stateDeductions: input.stateDeductions,
                stateCredits: input.stateCredits,
                totalIncome: input.income.totalIncome,
                taxRates: taxRates
            )
        }

        let taxSummaries = Self.taxSummariesFor(
            input: input,
            federalTaxes: federalData.taxes,
            stateTaxes: stateTaxes
        )

        return CalculatedTaxData(
            inputData: input,
            federalData: federalData,
            stateTaxes: stateTaxes,
            taxSummaries: taxSummaries
        )
    }
}

private extension TaxCalculator {
    static func calculateDeductionsForDeductionAmount(_ amount: DeductionAmount, standardDeduction: Double) -> Double {
        switch amount {
            case let .standard(additional): return additional + standardDeduction
            case let .custom(customAmount): return customAmount
        }
    }

    static func federalTaxesFor(income: Income, federalDeductions: DeductionAmount, federalCredits: Double, federalRates: FederalTaxRates) -> FederalTaxData {
        let deductions = Self.calculateDeductionsForDeductionAmount(
            federalDeductions,
            standardDeduction: federalRates.standardDeductions.value
        )
        let taxableFederalIncome = max(0.0, income.totalIncome - income.longtermCapitalGains - deductions)
        let namedTaxableFederalIncome = NamedValue(amount: taxableFederalIncome, name: "Taxable Income")

        var federalTaxes: [FederalTax] = []

        // income tax
        let incomeBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(federalRates.incomeRates)
        let incomeBracket = incomeBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        federalTaxes.append(
            FederalTax(title: "Income",
                       bracket: incomeBracket,
                       bracketGroup: incomeBracketGroup,
                       taxableIncome: namedTaxableFederalIncome)
        )

        // longterm gains tax
        let longtermGainBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(federalRates.longtermGainsRates)
        let longtermGainsBracket = longtermGainBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        if longtermGainsBracket.rate > 0.0 {
            federalTaxes.append(
                FederalTax(title: "Longterm Gains",
                           bracket: longtermGainsBracket,
                           bracketGroup: longtermGainBracketGroup,
                           taxableIncome: income.namedLongtermCapitalGains)
            )
        }

        // net investment income tax
        let niiBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(federalRates.netInvestmentIncomeRates)
        let niiBracket = niiBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        if niiBracket.rate > 0.0 {
            let taxableRegularIncome = taxableFederalIncome - niiBracket.startingAt
            let taxableNIIIncome = (income.totalCapitalGains < taxableRegularIncome
                ? income.namedTotalCapitalGains
                : NamedValue(amount: taxableRegularIncome, name: "Taxable Income for NII"))
            federalTaxes.append(
                FederalTax(title: "Net Investment Income",
                           bracket: niiBracket,
                           bracketGroup: niiBracketGroup,
                           taxableIncome: taxableNIIIncome)
            )
        }

        // additional medicare tax
        let medicareBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(federalRates.additionalMedicareIncomeRates)
        let medicareBracket = medicareBracketGroup.matchingBracketFor(taxableIncome: income.medicareWages)
        if medicareBracket.rate > 0.0 {
            let basicBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(federalRates.basicMedicareIncomeRates)
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

        return FederalTaxData(taxableIncome: taxableFederalIncome,
                              deductions: deductions,
                              credits: federalCredits,
                              taxes: federalTaxes)
    }

    static func stateTaxFor(stateIncome: StateIncome,
                            stateDeductions: [TaxState: DeductionAmount],
                            stateCredits: [TaxState: Double],
                            totalIncome: Double,
                            taxRates: RawTaxRatesYear) -> StateTax
    {
        let deductions = Self.calculateDeductionsForDeductionAmount(
            stateDeductions[stateIncome.state] ?? DeductionAmount.standard(),
            standardDeduction: taxRates.standardDeductionForState(stateIncome.state)
        )
        let taxableStateIncome = max(0.0, totalIncome + stateIncome.additionalStateIncome - deductions)
        let namedTaxableStateIncome = NamedValue(amount: taxableStateIncome, name: "Taxable State Income")

        let rawStateIncomeRates = taxRates.stateIncomeRates(for: stateIncome.state, taxableIncome: taxableStateIncome)
        let stateBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(rawStateIncomeRates)
        let bracket = stateBracketGroup.matchingBracketFor(taxableIncome: taxableStateIncome)

        let localTax = localTaxBracketForLocalTax(stateIncome.localTax,
                                                  taxableIncome: namedTaxableStateIncome,
                                                  taxRates: taxRates)

        return StateTax(state: stateIncome.state,
                        bracket: bracket,
                        bracketGroup: stateBracketGroup,
                        localTax: localTax,
                        taxableIncome: namedTaxableStateIncome,
                        additionalStateIncome: stateIncome.additionalStateIncome,
                        deductions: deductions,
                        withholdings: stateIncome.withholdings,
                        credits: stateCredits[stateIncome.state] ?? 0.0,
                        incomeRate: stateIncome.incomeRateGivenFederalIncome(totalIncome),
                        stateAttributedIncome: stateIncome.attributableIncomeGivenFederalIncome(totalIncome))
    }

    static func localTaxBracketForLocalTax(_ localTax: LocalTaxType, taxableIncome: NamedValue, taxRates: RawTaxRatesYear) -> LocalTax? {
        switch localTax {
            case .none:
                return nil
            case let .city(city):
                let rawLocalIncomeRates = taxRates.localIncomeRatesForCity(city, taxableIncome: taxableIncome.amount)
                let localBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(rawLocalIncomeRates)
                let bracket = localBracketGroup.matchingBracketFor(taxableIncome: taxableIncome.amount)

                return LocalTax(
                    city: city,
                    bracket: bracket,
                    bracketGroup: localBracketGroup,
                    taxableIncome: taxableIncome
                )
        }
    }

    static func taxSummariesFor(input: TaxDataInput, federalTaxes: [FederalTax], stateTaxes: [StateTax]) -> TaxSummaries {
        let fedTaxes = federalTaxes.reduce(0.0) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        // federal
        let federal = TaxSummary.fromTotalIncome(
            taxes: fedTaxes - input.federalCredits,
            withholdings: input.income.federalWithholdings + input.additionalFederalWithholding,
            totalIncome: input.income.totalIncome
        )

        // states
        var states: [TaxState: TaxSummary] = [:]
        for tax in stateTaxes {
            states[tax.state] = TaxSummary.fromTotalIncome(
                taxes: tax.taxAmount - (input.stateCredits[tax.state] ?? 0.0),
                withholdings: tax.withholdings,
                totalIncome: input.income.totalIncome
            )
        }

        // state summary
        var stateTotal = TaxSummary(taxes: 0.0, withholdings: 0.0, effectiveTaxRate: 0.0)
        for (_, summary) in states {
            stateTotal = stateTotal + summary
        }

        return TaxSummaries(
            federal: federal,
            states: states,
            stateTotal: stateTotal,
            total: federal + stateTotal
        )
    }
}
