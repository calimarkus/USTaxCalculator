//
//

import SwiftUI

struct AdditionView: View {
    var title: String
    let amount: Double

    var body: some View {
        CurrencyView(title: title,
                     amount: amount,
                     showPlusMinus: true,
                     isSecondaryLabel: true)
    }
}

struct SumView: View {
    var title: String
    var subtitle: String = ""
    let amount: Double

    var body: some View {
        CurrencyView(title: title, subtitle: subtitle, amount: amount, boldValue: true)
    }
}

struct CurrencyView: View {
    var title: String = ""
    var subtitle: String = ""
    var amount: Double
    var infoText: String? = nil

    var showPlusMinus: Bool = false
    var isSecondaryLabel: Bool = false
    var boldValue: Bool = false

    var titleText: String {
        let colon = (title.count > 0 && amount != 0.0 ? ":" : "")
        let spacing = (isSecondaryLabel ? "  " : "")
        return "\(spacing)\(title)\(colon)"
    }

    func amountText(amount: Double) -> String {
        let sanitizedAmount = amount == 0.0 ? abs(amount) : amount
        let plus = (showPlusMinus && sanitizedAmount > 0 ? "+" : "")
        return "\(plus)\(FormattingHelper.formatCurrency(sanitizedAmount))"
    }

    var valueColor: Color? {
        if showPlusMinus && amount < 0 {
            return .tax.taxReducingAmount
        } else {
            return nil
        }
    }

    var body: some View {
        LabeledExplainableValueView(titleText: titleText,
                                    subtitle: subtitle,
                                    valueText: amountText(amount: amount),
                                    infoText: infoText,
                                    isSecondaryLabel: isSecondaryLabel,
                                    boldValue: boldValue,
                                    valueColor: valueColor)
    }
}

struct LabeledExplainableValueView: View {
    var titleText: String
    var subtitle: String = ""
    var valueText: String = ""
    var infoText: String? = nil

    var isSecondaryLabel: Bool = false
    var boldValue: Bool = false
    var valueColor: Color? = nil

    var body: some View {
        LabeledValueView(title: titleText,
                         subtitle: subtitle,
                         isSecondaryLabel: isSecondaryLabel) {
            if valueText.count > 0 {
                ExplainableView(infoText: infoText) {
                    Text(valueText)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(boldValue ? .bold : .regular)
                        .foregroundColor(valueColor)
                }
            }
        }
    }
}

struct LabeledValueView<Content: View>: View {
    var title: String = ""
    var subtitle: String = ""
    var isSecondaryLabel: Bool = false

    @ViewBuilder let valueView: () -> Content

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isSecondaryLabel ? .secondary : .primary)

            if subtitle.count > 0 {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 20)

            valueView()
        }.padding(1.0)
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        TaxListGroupView {
            CurrencyView(title: "Alpha", amount: 123.53, infoText: "info")
            AdditionView(title: "Beta", amount: 25.25)
            AdditionView(title: "Gamma", amount: -12.23)
            SumView(title: "Total", amount: 123.53 + 25.25)
            CurrencyView(title: "PS", amount: -12.23)
            CurrencyView(title: "PS", subtitle: "(some explanation)", amount: 0.0)
            AdditionView(title: "Gamma", amount: -0.0)
        }.padding()
    }
}