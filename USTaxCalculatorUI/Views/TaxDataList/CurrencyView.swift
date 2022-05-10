//
//

import SwiftUI

struct AdditionView: View {
    var title: String
    let amount: Double?

    var body: some View {
        CurrencyView(title: title, amount: amount, isMathValue: true)
    }
}

struct SumView: View {
    var title: String
    var secondary: String = ""
    let amount: Double?

    var body: some View {
        CurrencyView(title: title, secondary: secondary, amount: amount, boldValue: true)
    }
}

struct CurrencyView: View {
    var title: String = ""
    var secondary: String = ""
    var amount: Double? = nil
    var isMathValue: Bool = false
    var boldValue: Bool = false
    var infoText: String? = nil

    var titleText: String {
        let colon = (title.count > 0 && amount != 0.0 ? ":" : "")
        let spacing = (isMathValue ? "  " : "")
        return "\(spacing)\(title)\(colon)"
    }

    func amountText(amount: Double) -> String {
        let sanitizedAmount = amount == 0.0 ? abs(amount) : amount
        let plus = (isMathValue && sanitizedAmount > 0 ? "+" : "")
        return "\(plus)\(FormattingHelper.formatCurrency(sanitizedAmount))"
    }

    var body: some View {
        HStack {
            Text(titleText)
                .foregroundColor(isMathValue ? .secondary : .primary)

            if secondary.count > 0 {
                Text(secondary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 20)

            if let amount = amount {
                ExplainableValueButton(valueText: amountText(amount: amount),
                                       infoText: infoText,
                                       bold: boldValue,
                                       valueColor: isMathValue && amount < 0 ? Color.tax.negativeAmount : nil)
            }
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                CurrencyView(title: "No Value Row")
                CurrencyView(title: "Alpha", amount: 123.53, infoText: "info")
                AdditionView(title: "Beta", amount: 25.25)
                AdditionView(title: "Gamma", amount: -12.23)
                SumView(title: "Total", amount: 123.53 + 25.25)
                CurrencyView(title: "PS", amount: -12.23)
                CurrencyView(title: "PS", amount: 0.0)
                AdditionView(title: "Gamma", amount: -0.0)
            }
        }
        .listStyle(.inset(alternatesRowBackgrounds: true))
    }
}
