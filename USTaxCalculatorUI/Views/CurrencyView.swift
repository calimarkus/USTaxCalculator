//
//

import SwiftUI

struct AdditionView: View {
    var title: String
    let amount: Double

    var body: some View {
        CurrencyView(title: title, amount: amount, isMathValue: true)
    }
}

struct SumView: View {
    var title: String
    var secondary: String = ""
    let amount: Double

    var body: some View {
        CurrencyView(title: title, secondary: secondary, amount: amount, boldValue: true)
    }
}

struct CurrencyView: View {
    var title: String = ""
    var secondary: String = ""
    var amount: Double = 0.0
    var isMathValue: Bool = false
    var boldValue: Bool = false

    var titleText: String {
        let colon = (title.count > 0 && amount != 0.0 ? ":" : "")
        let spacing = (isMathValue ? "  " : "")
        return "\(spacing)\(title)\(colon)"
    }

    var amountText: String {
        let plus = (isMathValue && amount >= 0 ? "+" : "")
        return "\(plus)\(FormattingHelper.formatCurrency(amount))"
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(titleText)
                .foregroundColor(isMathValue ? .secondary : .primary)
            if secondary.count > 0 {
                Text(secondary)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 20)
            if amount != 0.0 {
                Text(amountText)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(boldValue ? .bold : .regular)
                    .foregroundColor(isMathValue && amount < 0 ? Color.tax.negativeAmount : nil)
            }
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CurrencyView(title: "No Value Row")
            CurrencyView(title: "Alpha", amount: 123.53)
            AdditionView(title: "Beta", amount: 25.25)
            AdditionView(title: "Gamma", amount: -12.23)
            SumView(title: "Totes", amount: 123.53 + 25.25)
            CurrencyView(title: "Gamma", amount: -12.23)
        }
    }
}
