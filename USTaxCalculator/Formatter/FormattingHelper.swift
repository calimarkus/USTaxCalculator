//
//

import Foundation

struct FormattingHelper {
    static func formattedTitle(taxdata: CalculatedTaxData) -> String {
        formattedTitle(taxyear: taxdata.taxYear,
                       filingType: taxdata.filingType,
                       states: taxdata.stateTaxes.map(\.state))
    }

    static func formattedTitle(taxDataInput: TaxDataInput) -> String {
        formattedTitle(taxyear: taxDataInput.taxYear,
                       filingType: taxDataInput.filingType,
                       states: taxDataInput.income.stateIncomes.map(\.state))
    }

    private static func formattedTitle(taxyear: TaxYear, filingType: FilingType, states: [TaxState]) -> String {
        "Year \(taxyear.rawValue), \(filingType.rawValue), \(formattedStates(states: states))"
    }

    static func formattedStates(states: [TaxState]) -> String {
        states.map { "\($0)" }.joined(separator: "+")
    }

    static func formattedTaxYearShort(taxData: CalculatedTaxData) -> String {
        "'" + String(taxData.taxYear.rawValue).suffix(2)
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
        if bracket.startingAt > 0.0 {
            return "\(formatPercentage(bracket.rate, locale: locale)) over \(formattedBracketStart(bracket, locale: locale))"
        } else {
            return formatPercentage(bracket.rate, locale: locale)
        }
    }
}
