//
//

import SwiftUI

struct AdditionView: View {
    var title: String
    let amount: Double
    var showSeparator: Bool = true

    var body: some View {
        CurrencyView(title: title,
                     amount: amount,
                     showPlusMinus: true,
                     showSeparator: showSeparator,
                     isSecondaryLabel: true)
    }
}

struct SumView: View {
    var title: String
    var subtitle: String = ""
    let amount: Double
    var showSeparator: Bool = true

    var body: some View {
        CurrencyView(title: title, subtitle: subtitle, amount: amount, showSeparator: showSeparator, boldValue: true)
    }
}

struct CurrencyView: View {
    var title: String = ""
    var subtitle: String = ""
    var amount: Double
    var infoText: String? = nil

    var showPlusMinus: Bool = false
    var showSeparator: Bool = true
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
        let valueText = amountText(amount: amount)

        LabeledValueView(title: titleText,
                         subtitle: subtitle,
                         showSeparator: showSeparator,
                         isSecondaryLabel: isSecondaryLabel) {
            ExplainableView(infoText: infoText) {
                Text(valueText)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(boldValue ? .bold : .regular)
                    .foregroundColor(valueColor)
            }
        }
    }
}

struct LabeledExplainableValueView: View {
    var titleText: String
    var valueText: String
    var infoText: String? = nil
    var showSeparator: Bool = true

    var body: some View {
        LabeledValueView(title: titleText,
                         subtitle: "",
                         showSeparator: showSeparator,
                         isSecondaryLabel: false) {
            ExplainableView(infoText: infoText) {
                Text(valueText)
                    .font(.system(.body, design: .monospaced))
            }
        }
    }
}

struct LabeledValueView<Content: View>: View {
    let title: String
    let subtitle: String
    let showSeparator: Bool
    let isSecondaryLabel: Bool
    let valueView: Content

    init(title: String = "",
         subtitle: String = "",
         showSeparator: Bool = true,
         isSecondaryLabel: Bool = false,
         @ViewBuilder valueView: () -> Content)
    {
        self.title = title
        self.subtitle = subtitle
        self.showSeparator = showSeparator
        self.isSecondaryLabel = isSecondaryLabel
        self.valueView = valueView()
    }

    var body: some View {
        VStack {
            if showSeparator {
                Color.primary
                    .opacity(0.1)
                    .frame(height: 1.0)
                    .padding(.leading, isSecondaryLabel ? 7.5 : 0.5)
                    .padding(.trailing, -10.0)
            }

            HStack {
                Text(title)
                    .foregroundColor(isSecondaryLabel ? .secondary : .primary)

                if subtitle.count > 0 {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer(minLength: 20)

                valueView
            }
            .padding(.top, -0.5)
            .padding(.bottom, -0.5)
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        TaxListGroupView {
            CurrencyView(title: "Alpha", amount: 123.53, infoText: "info", showSeparator: false)
            AdditionView(title: "Beta", amount: 25.25)
            AdditionView(title: "Gamma", amount: -12.23)
            SumView(title: "Total", amount: 123.53 + 25.25)
            CurrencyView(title: "PS", amount: -12.23)
            CurrencyView(title: "PS", subtitle: "(some explanation)", amount: 0.0)
            AdditionView(title: "Gamma", amount: -0.0)
        }.padding()
    }
}
