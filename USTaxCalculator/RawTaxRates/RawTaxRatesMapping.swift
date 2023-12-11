//
// RawTaxRatesMapping.swift
//

extension RawTaxRatesYear {
    fileprivate func group(for filingType: FilingType) -> RawTaxRatesGroup {
        switch filingType {
            case .single: return singleRates
            case .marriedJointly: return marriedJointlyRates
        }
    }
}

extension RawTaxRatesGroup {
    private static func forTaxYear(_ taxYear: TaxYear) -> RawTaxRatesYear {
        switch taxYear {
            case .y2020: return RawTaxRates2020()
            case .y2021: return RawTaxRates2021()
            case .y2022: return RawTaxRates2022()
        }
    }

    static func taxRatesGroup(for taxYear: TaxYear, _ filingType: FilingType) -> RawTaxRatesGroup {
        return forTaxYear(taxYear).group(for: filingType)
    }
}

extension RawTaxRatesGroup {
    func standardDeductionForState(_ state: TaxState) -> RawStandardDeduction {
        switch state {
            case .NY: return newYorkRates.standardDeductions
            case .CA: return californiaRates.standardDeductions
        }
    }

    func stateIncomeRates(for state: TaxState, taxableIncome: Double) -> RawTaxRates {
        switch state {
            case .CA: return californiaRates.incomeRates(forIncome: taxableIncome)
            case .NY: return newYorkRates.incomeRates(forIncome: taxableIncome)
        }
    }

    func localIncomeRatesForCity(_ city: TaxCity, taxableIncome _: Double) -> RawTaxRates {
        switch city {
            case .NYC: return newYorkRates.newYorkCityRates
        }
    }
}
