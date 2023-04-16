//
// FormattingHelper.swift
//

import Foundation

extension CalculatedTaxData {
    var formattedTitle: String {
        title.count > 0 ? title : infoTitle
    }

    var formattedSubtitle: String? {
        title.count > 0 ? infoTitle : nil
    }

    private var infoTitle: String {
        FormattingHelper.formattedTaxYear(taxYear, filingType, states: stateTaxes.map(\.state))
    }
}

extension TaxDataInput {
    var formattedTitle: String {
        FormattingHelper.formattedTaxYear(taxYear, filingType, states: income.stateIncomes.map(\.state))
    }
}

extension TaxBracket {
    var formattedString: String {
        formattedStringWith(locale: nil)
    }

    func formattedStringWith(locale: Locale?) -> String {
        if startingAt > 0.0 {
            return "\(FormattingHelper.formatPercentage(rate, locale: locale)) over \(formattedBracketStart(locale: locale))"
        } else {
            return FormattingHelper.formatPercentage(rate, locale: locale)
        }
    }

    private func formattedBracketStart(locale: Locale? = nil) -> String {
        var val = startingAt / 1000.0
        var symbol = "K"
        if val > 1000.0 {
            val /= 1000.0
            symbol = "M"
        }
        return "\(FormattingHelper.formatCurrency(val, locale: locale))\(symbol)+"
    }
}

enum FormattingHelper {
    fileprivate static func formattedTaxYear(_ taxyear: TaxYear, _ filingType: FilingType, states: [TaxState]) -> String {
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
        formatter.roundingMode = num >= 0 ? .ceiling : .floor
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
