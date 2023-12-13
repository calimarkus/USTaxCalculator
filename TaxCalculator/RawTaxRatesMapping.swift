//
//

import TaxPrimitives
import TaxRates

fileprivate extension TaxYear {
    // MARK: tax year mapping
    var rates: RawTaxRatesYear {
        switch self {
            case .y2020: return RawTaxRates2020()
            case .y2021: return RawTaxRates2021()
            case .y2022: return RawTaxRates2022()
        }
    }
}

extension RawTaxRatesGroup {
    // MARK: tax state mapping
    public func rawStateTaxRates(for state: TaxState) -> RawStateTaxRates {
        switch state {
            case .NY: return newYorkRates
            case .CA: return californiaRates
        }
    }

    // MARK: tax year & filing type mapping
    public static func taxRatesGroup(for taxYear: TaxYear, _ filingType: FilingType) -> RawTaxRatesGroup {
        let rates = taxYear.rates
        switch filingType {
            case .single: return rates.singleRates
            case .marriedJointly: return rates.marriedJointlyRates
        }
    }

    // MARK: Additional tax mapping

    func mentalHealthRates(for state: TaxState) -> RawTaxRates? {
        guard state == .CA else { return nil }
        return californiaRates.mentalHealthRates
    }

    func localIncomeRatesForCity(_ city: TaxCity, taxableIncome _: Double) -> RawTaxRates {
        switch city {
            case .NYC: return newYorkRates.newYorkCityRates
        }
    }
}
