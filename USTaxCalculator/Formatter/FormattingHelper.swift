//
//

import Foundation

struct FormattingHelper {
    static func formattedTitle(taxData: USTaxData) -> String {
        var additionalTitle = ""
        if let t = taxData.title { additionalTitle = "- \(t)" }
        let statesString = taxData.stateTaxes.map { "\($0.state)" }.joined(separator: "+")
        let title = "Year \(taxData.taxYear.rawValue), \(taxData.filingType.rawValue), \(statesString) \(additionalTitle)"
        return title.uppercased()
    }

    static func formattedShortTitle(taxData: USTaxData) -> String {
        return "\(taxData.title ?? taxData.filingType.rawValue) '\(String(taxData.taxYear.rawValue).suffix(2))"
    }

    static func formatExplanation(_ tax: Tax, explanationsEnabled: Bool) -> String {
        return (explanationsEnabled
            ? String(repeating: " ", count: 15) + "Math: \(tax.bracket.taxCalculationExplanation(tax.taxableIncome))"
            : "")
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

    static func formattedBracketStart(_ bracket: TaxBracket, locale: Locale? = nil) -> String {
        var val = bracket.startingAt / 1000.0
        var symbol = "K"
        if val > 1000.0 {
            val /= 1000.0
            symbol = "M"
        }
        return "\(formatCurrency(val, locale: locale))\(symbol)+"
    }

    static func formattedBracketInfo(_ bracket: TaxBracket, locale: Locale? = nil) -> String {
        return "\(formatPercentage(bracket.rate, locale: locale)) over \(formattedBracketStart(bracket, locale: locale))"
    }
}
