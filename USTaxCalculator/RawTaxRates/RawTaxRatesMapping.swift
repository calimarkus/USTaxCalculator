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
    func rawStateRates(for state: TaxState)  -> RawStateTaxRates {
        switch state {
            case .NY: return newYorkRates
            case .CA: return californiaRates
        }
    }

    func localIncomeRatesForCity(_ city: TaxCity, taxableIncome _: Double) -> RawTaxRates {
        switch city {
            case .NYC: return newYorkRates.newYorkCityRates
        }
    }
}
