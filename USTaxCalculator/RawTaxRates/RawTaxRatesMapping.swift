//
// RawTaxRatesMapping.swift
//

extension RawTaxRatesYear {
    static func taxRatesYearFor(_ taxYear: TaxYear, _ filingType: FilingType) -> RawTaxRatesYear {
        switch taxYear {
            case .y2020:
                switch filingType {
                    case .single:
                        return TaxYear2020_Single.taxRates
                    case .marriedJointly:
                        return TaxYear2020_MarriedJointly.taxRates
                }
            case .y2021:
                switch filingType {
                    case .single:
                        return TaxYear2021_Single.taxRates
                    case .marriedJointly:
                        return TaxYear2021_MarriedJointly.taxRates
                }
            case .y2022:
                switch filingType {
                    case .single:
                        return TaxYear2022_Single.taxRates
                    case .marriedJointly:
                        return TaxYear2022_MarriedJointly.taxRates
                }
        }
    }
}

extension RawTaxRatesYear {
    func standardDeductionForState(_ state: TaxState) -> RawStandardDeduction {
        switch state {
            case .NY:
                return newYorkRates.standardDeductions
            case .CA:
                return californiaRates.standardDeductions
        }
    }

    func stateIncomeRates(for state: TaxState, taxableIncome: Double) -> RawTaxRates {
        switch state {
            case .CA:
                // CA doesn't use progressive rates for incomes lower or equal to 100,000
                if let lowIncomeRates = californiaRates.lowIncomeRates, taxableIncome <= 100_000 {
                    return lowIncomeRates
                } else {
                    return californiaRates.incomeRates
                }

            case .NY:
                // new york doesn't use progressive rates for incomes higher than 107,650
                // see comments on RawTaxRates.highIncomeRates
                if taxableIncome > 107_650 {
                    return newYorkRates.highIncomeRates
                } else {
                    return newYorkRates.incomeRates
                }
        }
    }

    func localIncomeRatesForCity(_ city: TaxCity, taxableIncome _: Double) -> RawTaxRates {
        switch city {
            case .NYC: return newYorkRates.newYorkCityRates
        }
    }
}
