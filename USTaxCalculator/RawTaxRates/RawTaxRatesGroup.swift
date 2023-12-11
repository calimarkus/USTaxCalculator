//
// RawTaxRatesGroup.swift
//

fileprivate extension TaxYear {
    var rates: RawTaxRatesYear {
        switch self {
            case .y2020: return RawTaxRates2020()
            case .y2021: return RawTaxRates2021()
            case .y2022: return RawTaxRates2022()
        }
    }
}

protocol RawTaxRatesYear {
    var singleRates: RawTaxRatesGroup { get }
    var marriedJointlyRates: RawTaxRatesGroup { get }
}

struct RawTaxRatesGroup {
    let federalRates: RawFederalTaxRates
    private let californiaRates: RawCaliforniaStateTaxRates
    private let newYorkRates: RawNewYorkStateTaxRates

    init(federalRates: RawFederalTaxRates, californiaRates: RawCaliforniaStateTaxRates, newYorkRates: RawNewYorkStateTaxRates) {
        self.federalRates = federalRates
        self.californiaRates = californiaRates
        self.newYorkRates = newYorkRates
    }

    func rawStateTaxRates(for state: TaxState) -> RawStateTaxRates {
        switch state {
            case .NY: return newYorkRates
            case .CA: return californiaRates
        }
    }
}

// MARK: static getter

extension RawTaxRatesGroup {
    static func taxRatesGroup(for taxYear: TaxYear, _ filingType: FilingType) -> RawTaxRatesGroup {
        let rates = taxYear.rates
        switch filingType {
            case .single: return rates.singleRates
            case .marriedJointly: return rates.marriedJointlyRates
        }
    }
}

// MARK: Additional taxes

extension RawTaxRatesGroup {

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
