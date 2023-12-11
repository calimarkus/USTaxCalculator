//
// TaxCalculator.swift
//

enum TaxCalculator {
    static func calculateTaxesForInput(_ input: TaxDataInput) -> CalculatedTaxData {
        let taxRates = RawTaxRatesGroup.group(for: input.taxYear, input.filingType)

        let federalData = Self.federalTaxesFor(
            income: input.income,
            deductions: input.federalDeductions,
            withholdings: input.totalFederalWitholdings,
            credits: input.federalCredits,
            taxRates: taxRates.federalRates
        )

        let stateTaxDatas = input.income.stateIncomes.map { stateIncome in
            Self.stateTaxDataFor(
                stateIncome: stateIncome,
                stateDeductions: input.stateDeductions,
                stateCredits: input.stateCredits,
                totalIncome: input.income.namedTotalIncome,
                taxRates: taxRates
            )
        }

        let initial = TaxSummary(taxes: 0.0, withholdings: 0.0, totalIncome: -1.0)
        let statesSummary = stateTaxDatas.reduce(initial) { partialResult, taxData in
            partialResult + taxData.summary
        }

        return CalculatedTaxData(
            inputData: input,
            federalData: federalData,
            stateTaxDatas: stateTaxDatas,
            statesSummary: statesSummary,
            totalSummary: federalData.summary + statesSummary
        )
    }
}

private extension TaxCalculator {
    static func federalTaxesFor(income: Income, deductions: DeductionInput, withholdings: Double, credits: Double, taxRates: FederalTaxRates) -> FederalTaxData {
        let deduction = Deduction(input: deductions, standardDeduction: taxRates.standardDeductions)
        let taxableFederalIncome = max(0.0, income.totalIncome - income.longtermCapitalGains - deduction.amount)
        let namedTaxableFederalIncome = NamedValue(amount: taxableFederalIncome, name: "Taxable Income")

        var federalTaxes: [BasicTax] = []

        // income tax
        let incomeBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(taxRates.incomeRates)
        let incomeBracket = incomeBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        federalTaxes.append(
            BasicTax(title: "Income",
                     activeBracket: incomeBracket,
                     bracketGroup: incomeBracketGroup,
                     taxableIncome: namedTaxableFederalIncome)
        )

        // longterm gains tax
        let longtermGainBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(taxRates.longtermGainsRates)
        let longtermGainsBracket = longtermGainBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        if longtermGainsBracket.rate > 0.0, income.namedLongtermCapitalGains.amount > 0.0 {
            federalTaxes.append(
                BasicTax(title: "Longterm Gains",
                         activeBracket: longtermGainsBracket,
                         bracketGroup: longtermGainBracketGroup,
                         taxableIncome: income.namedLongtermCapitalGains)
            )
        }

        // net investment income tax
        let niiBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(taxRates.netInvestmentIncomeRates)
        let niiBracket = niiBracketGroup.matchingBracketFor(taxableIncome: taxableFederalIncome)
        if niiBracket.rate > 0.0 {
            let taxableRegularIncome = taxableFederalIncome - niiBracket.startingAt
            let taxableNIIIncome = (income.totalCapitalGains < taxableRegularIncome
                ? income.namedTotalCapitalGains
                : NamedValue(amount: taxableRegularIncome, name: "Taxable Income for NII"))
            federalTaxes.append(
                BasicTax(title: "Net Investment Income",
                         activeBracket: niiBracket,
                         bracketGroup: niiBracketGroup,
                         taxableIncome: taxableNIIIncome)
            )
        }

        // additional medicare tax
        let medicareBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(taxRates.additionalMedicareIncomeRates)
        let medicareBracket = medicareBracketGroup.matchingBracketFor(taxableIncome: income.medicareWages)
        if medicareBracket.rate > 0.0 {
            let basicBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(taxRates.basicMedicareIncomeRates)
            let basicBracket = basicBracketGroup.matchingBracketFor(taxableIncome: income.medicareWages)
            let expectedBasicWithholding = income.medicareWages * basicBracket.rate
            let tax = BasicTax(title: "Additional Medicare",
                               activeBracket: medicareBracket,
                               bracketGroup: medicareBracketGroup,
                               taxableIncome: income.namedMedicareWages)
            let expectedTotalWithholding = expectedBasicWithholding + tax.taxAmount

            // only apply additional medicare tax, if not already withheld
            if income.medicareWithholdings < expectedTotalWithholding {
                federalTaxes.append(tax)
            }
        }

        // total federal taxes
        let totalTaxes = federalTaxes.reduce(0.0) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        // summary
        let federalSummary = TaxSummary(
            taxes: totalTaxes - credits,
            withholdings: withholdings,
            totalIncome: income.totalIncome
        )

        return FederalTaxData(taxes: federalTaxes,
                              totalTaxableIncome: taxableFederalIncome,
                              totalTaxes: totalTaxes,
                              deduction: deduction,
                              withholdings: withholdings,
                              credits: credits,
                              summary: federalSummary)
    }

    static func stateTaxDataFor(stateIncome: StateIncome,
                                stateDeductions: [TaxState: DeductionInput],
                                stateCredits: [TaxState: Double],
                                totalIncome: NamedValue,
                                taxRates: RawTaxRatesGroup) -> StateTaxData
    {
        let state = stateIncome.state
        let credits = stateCredits[state] ?? 0.0

        let deduction = Deduction(
            input: stateDeductions[state] ?? DeductionInput.standard(),
            standardDeduction: taxRates.standardDeductionForState(state)
        )
        let taxableStateIncome = max(0.0, totalIncome.amount + stateIncome.additionalStateIncome - deduction.amount)
        let namedTaxableStateIncome = NamedValue(amount: taxableStateIncome, name: "Taxable State Income")

        let rawStateIncomeRates = taxRates.stateIncomeRates(for: state, taxableIncome: taxableStateIncome)
        let stateBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(rawStateIncomeRates)
        let bracket = stateBracketGroup.matchingBracketFor(taxableIncome: taxableStateIncome)

        let attributedIncome = AttributableIncome(name: "State Income",
                                                  incomeAmount: stateIncome.wages,
                                                  totalIncome: totalIncome)

        let stateTax = AttributableTax(title: "\(state) State",
                                       activeBracket: bracket,
                                       bracketGroup: stateBracketGroup,
                                       taxableIncome: namedTaxableStateIncome,
                                       attributedRate: attributedIncome.rate)

        var stateTaxes = [stateTax]

        let additionalTax = Self.additionalTaxForState(state, taxRates: taxRates, namedTaxableStateIncome: namedTaxableStateIncome, attributedIncome: attributedIncome)
        if let additionalTax {
            stateTaxes.append(additionalTax)
        }

        let totalStateTaxes = stateTaxes.reduce(0.0) { partialResult, tax in
            partialResult + tax.taxAmount
        }

        let localTax = localTaxBracketForLocalTax(stateIncome.localTax,
                                                  taxableIncome: namedTaxableStateIncome,
                                                  taxRates: taxRates)

        let stateSummary = TaxSummary(
            taxes: totalStateTaxes + (localTax?.taxAmount ?? 0.0) - credits,
            withholdings: stateIncome.withholdings,
            totalIncome: totalIncome.amount
        )

        return StateTaxData(state: state,
                            attributableIncome: attributedIncome,
                            taxes: stateTaxes,
                            localTax: localTax,
                            taxableStateIncome: namedTaxableStateIncome,
                            additionalStateIncome: stateIncome.additionalStateIncome,
                            deduction: deduction,
                            withholdings: stateIncome.withholdings,
                            credits: credits,
                            summary: stateSummary)
    }

    static func additionalTaxForState(_ state: TaxState,
                                      taxRates: RawTaxRatesGroup,
                                      namedTaxableStateIncome: NamedValue,
                                      attributedIncome: AttributableIncome) -> AttributableTax?
    {
        if state == .CA {
            let mentalHealthRates = taxRates.californiaRates.mentalHealthRates
            let mentalHealthBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(mentalHealthRates)
            let bracket = mentalHealthBracketGroup.matchingBracketFor(taxableIncome: namedTaxableStateIncome.amount)
            if bracket.rate > 0.0 {
                return AttributableTax(title: "CA Mental Health",
                                       activeBracket: bracket,
                                       bracketGroup: mentalHealthBracketGroup,
                                       taxableIncome: namedTaxableStateIncome,
                                       attributedRate: attributedIncome.rate)
            }
        }
        return nil
    }

    static func localTaxBracketForLocalTax(_ localTax: LocalTaxType, taxableIncome: NamedValue, taxRates: RawTaxRatesGroup) -> BasicTax? {
        switch localTax {
            case .none:
                return nil
            case let .city(city):
                let rawLocalIncomeRates = taxRates.localIncomeRatesForCity(city, taxableIncome: taxableIncome.amount)
                let localBracketGroup = TaxBracketGenerator.bracketGroupForRawTaxRates(rawLocalIncomeRates)
                let bracket = localBracketGroup.matchingBracketFor(taxableIncome: taxableIncome.amount)

                return BasicTax(
                    title: "\(city) Local",
                    activeBracket: bracket,
                    bracketGroup: localBracketGroup,
                    taxableIncome: taxableIncome
                )
        }
    }
}
