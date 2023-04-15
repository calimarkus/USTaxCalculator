//
//

enum TaxBracketFactory {}

// federal tax bracket
extension TaxBracketFactory {
    static func federalTaxBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        return try TaxBracketGenerator.bracketsForRawTaxRates(RawFederalTaxRates.progressiveIncomeRates[year]?[filingType])
    }

    static func federalLongtermGainsBrackets(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        return try TaxBracketGenerator.bracketsForRawTaxRates(RawFederalTaxRates.longtermGainsRates[year]?[filingType])
    }

    static func netInvestmentIncomeBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        return try TaxBracketGenerator.bracketsForRawTaxRates(RawFederalTaxRates.netInvestmentIncomeRates[year]?[filingType])
    }

    static func basicMedicareBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        return try TaxBracketGenerator.bracketsForRawTaxRates(RawFederalTaxRates.basicMedicareIncomeRates[year]?[filingType])
    }

    static func additionalMedicareBracketsFor(taxYear year: TaxYear, filingType: FilingType) throws -> TaxBracketGroup {
        return try TaxBracketGenerator.bracketsForRawTaxRates(RawFederalTaxRates.additionalMedicareIncomeRates[year]?[filingType])
    }
}

// state tax brackets
extension TaxBracketFactory {
    static func stateTaxBracketFor(_ state: TaxState, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        switch state {
        case .CA:
            return try TaxBracketGenerator.bracketsForRawTaxRates(RawStateTaxRates.californiaRates[year]?[filingType])

        case .NY:
            // new york doesn't use progressive rates for incomes higher than 107,650
            // see comments on RawTaxRates.nonProgressiveNewYorkStateRates
            if taxableIncome > 107650 {
                return try TaxBracketGenerator.bracketsForRawTaxRates(RawStateTaxRates.nonProgressiveNewYorkStateRates[year]?[filingType])
            } else {
                return try TaxBracketGenerator.bracketsForRawTaxRates(RawStateTaxRates.progressiveNewYorkStateRates[year]?[filingType])
            }
        }
    }
}

// city tax brackets
extension TaxBracketFactory {
    static func cityTaxBracketFor(_ city: TaxCity, taxYear year: TaxYear, filingType: FilingType, taxableIncome: Double) throws -> TaxBracketGroup {
        switch city {
        case .NYC: return try TaxBracketGenerator.bracketsForRawTaxRates(RawCityTaxRates.newYorkCityRates[year]?[filingType])
        }
    }
}
