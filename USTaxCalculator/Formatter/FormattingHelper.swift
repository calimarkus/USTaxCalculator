//
//

import Foundation

struct FormattingHelper {
    static func formattedTitle(taxData: USTaxData) -> String {
        var additionalTitle = ""
        if let t = taxData.title { additionalTitle = "- \(t)" }
        let title = "Year \(taxData.taxYear.rawValue), \(taxData.filingType.rawValue), \(formattedStates(taxData: taxData)) \(additionalTitle)"
        return title.uppercased()
    }

    static func formattedStates(taxData: USTaxData) -> String {
        return taxData.stateTaxes.map { "\($0.state)" }.joined(separator: "+")
    }

    static func formattedTaxYearShort(taxData: USTaxData) -> String {
        return "'" + String(taxData.taxYear.rawValue).suffix(2)
    }

    static func formattedShortTitle(taxData: USTaxData) -> String {
        return "\(taxData.title ?? taxData.filingType.rawValue)"
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
