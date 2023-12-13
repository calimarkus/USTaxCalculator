//
// RawTaxRatesGroup.swift
//

public protocol RawTaxRatesYear {
    var singleRates: RawTaxRatesGroup { get }
    var marriedJointlyRates: RawTaxRatesGroup { get }
}

public struct RawTaxRatesGroup {
    public let federalRates: RawFederalTaxRates
    public let californiaRates: RawCaliforniaStateTaxRates
    public let newYorkRates: RawNewYorkStateTaxRates

    init(federalRates: RawFederalTaxRates, californiaRates: RawCaliforniaStateTaxRates, newYorkRates: RawNewYorkStateTaxRates) {
        self.federalRates = federalRates
        self.californiaRates = californiaRates
        self.newYorkRates = newYorkRates
    }
}
