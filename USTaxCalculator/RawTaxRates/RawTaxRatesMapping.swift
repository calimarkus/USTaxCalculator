//
// RawTaxRatesMapping.swift
//

extension RawTaxRatesYear {
    static func rates(for filingType: FilingType) -> RawTaxRatesGroup {
        switch filingType {
            case .single:
                return singleRates
            case .marriedJointly:
                return marriedJointlyRates
        }
    }
}

extension RawTaxRates2020: RawTaxRatesYear {}

extension RawTaxRatesGroup {
    static func group(for taxYear: TaxYear, _ filingType: FilingType) -> RawTaxRatesGroup {
        switch taxYear {
            case .y2020:
                return RawTaxRates2020.rates(for: filingType)
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

extension RawTaxRatesGroup {
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
                if californiaRates.isEligableForLowIncomeRates(taxableIncome) {
                    return californiaRates.lowIncomeRates
                } else {
                    return californiaRates.incomeRates
                }

            case .NY:
                if newYorkRates.isEligableForHighIncomeRates(taxableIncome) {
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
