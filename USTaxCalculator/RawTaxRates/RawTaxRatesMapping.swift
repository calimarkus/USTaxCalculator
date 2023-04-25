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
                guard let eligibilityCheck = californiaRates.lowIncomeRateEligibility, let lowIncomeRates = californiaRates.lowIncomeRates else {
                    return californiaRates.incomeRates
                }

                if eligibilityCheck(taxableIncome) {
                    return lowIncomeRates
                } else {
                    return californiaRates.incomeRates
                }

            case .NY:
                if newYorkRates.highIncomeRateEligibility(taxableIncome) {
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
