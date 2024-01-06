//
//

import Foundation
import TaxInputModels
import TaxOutputModels

public extension CalculatedTaxData {
    var formattedTitle: String {
        title.count > 0 ? title : infoTitle
    }

    var formattedSubtitle: String? {
        title.count > 0 ? infoTitle : nil
    }

    private var infoTitle: String {
        FormattingHelper.formattedTaxYear(taxYear, filingType, states: stateTaxDatas.map(\.state))
    }
}

public extension TaxDataInput {
    var formattedTitle: String {
        FormattingHelper.formattedTaxYear(taxYear, filingType, states: income.stateIncomes.map(\.state))
    }
}

public extension TaxBracket {
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
