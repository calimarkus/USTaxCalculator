//
//

extension TaxYear {
    func rawTaxRates() -> RawTaxRatesYear {
        switch self {
            case .y2020:
                return TaxYear2020.taxRates
            case .y2021:
                return TaxYear2021.taxRates
            case .y2022:
                return TaxYear2022.taxRates
        }
    }
}

extension RawTaxRatesYear {
    func standardDeductionForState(_ state: TaxState) -> [FilingType: Double] {
        switch state {
            case .NY:
                return newYorkRates.standardDeductions
            case .CA:
                return californiaRates.standardDeductions
        }
    }

    func stateIncomeRatesForState(_ state: TaxState, taxableIncome: Double) -> [FilingType: RawTaxRates] {
        switch state {
            case .CA:
                return californiaRates.incomeRates

            case .NY:
                // new york doesn't use progressive rates for incomes higher than 107,650
                // see comments on RawTaxRates.nonProgressiveNewYorkStateRates
                if taxableIncome > 107650 {
                    return newYorkRates.nonProgressiveIncomeRates
                } else {
                    return newYorkRates.incomeRates
                }
        }
    }

    func localIncomeRatesForCity(_ city: TaxCity, taxableIncome: Double) -> [FilingType: RawTaxRates] {
        switch city {
            case .NYC: return newYorkRates.newYorkCityRates
        }
    }
}
