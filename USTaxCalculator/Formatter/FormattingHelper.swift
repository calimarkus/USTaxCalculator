//
// FormattingHelper.swift
//

import Foundation
import TaxPrimitives

enum FormattingHelper {
    static func formattedTaxYear(_ taxyear: TaxYear, _ filingType: FilingType, states: [TaxState]) -> String {
        "Year \(taxyear.rawValue), \(filingType.rawValue), \(formattedStates(states: states))"
    }

    static func formattedStates(states: [TaxState]) -> String {
        states.map { "\($0)" }.joined(separator: "+")
    }

    static func formatCurrency(_ num: Double, locale: Locale? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        formatter.maximumFractionDigits = 0
        return formatter.string(from: num as NSNumber)!
    }

    static func formatPercentage(_ rate: Double, locale: Locale? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = locale
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1

        return formatter.string(from: rate as NSNumber)!
    }
}
