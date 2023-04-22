//
// CurrencyView.swift
//

import SwiftUI

struct CurrencyViewConfig {
    var title: String = ""
    var subtitle: String = ""
    var amount: Double = 0.0

    var showPlusMinus: Bool = false
    var showSeparator: Bool = true
    var isSecondaryLabel: Bool = false
    var boldValue: Bool = false

    fileprivate var titleText: String {
        let colon = (title.count > 0 && amount != 0.0 ? ":" : "")
        let spacing = (isSecondaryLabel ? "  " : "")
        return "\(spacing)\(title)\(colon)"
    }

    fileprivate func amountText(amount: Double) -> String {
        let sanitizedAmount = amount == 0.0 ? abs(amount) : amount
        let plus = (showPlusMinus && sanitizedAmount > 0 ? "+" : "")
        return "\(plus)\(FormattingHelper.formatCurrency(sanitizedAmount))"
    }

    fileprivate var valueColor: Color? {
        if showPlusMinus, amount < 0 {
            return .tax.taxReducingAmount
        } else {
            return nil
        }
    }
}

extension CurrencyViewConfig {
    static func secondaryAdditionConfig(title: String, amount: Double) -> CurrencyViewConfig {
        CurrencyViewConfig(
            title: title,
            amount: amount,
            showPlusMinus: true,
            showSeparator: true,
            isSecondaryLabel: true
        )
    }

    static func boldSumConfig(title: String, subtitle: String = "", amount: Double, showSeparator: Bool = true) -> CurrencyViewConfig {
        CurrencyViewConfig(
            title: title,
            subtitle: subtitle,
            amount: amount,
            showSeparator: showSeparator,
            boldValue: true
        )
    }
}

private struct CurrencyViewText: View {
    var config: CurrencyViewConfig

    init(_ config: CurrencyViewConfig) {
        self.config = config
    }

    var body: some View {
        Text(config.amountText(amount: config.amount))
            .font(.system(.body, design: .monospaced))
            .fontWeight(config.boldValue ? .bold : .regular)
            .foregroundColor(config.valueColor)
    }
}

struct CurrencyView: View {
    var config: CurrencyViewConfig

    init(_ config: CurrencyViewConfig) {
        self.config = config
    }

    var body: some View {
        LabeledValueView(title: config.titleText,
                         subtitle: config.subtitle,
                         showSeparator: config.showSeparator,
                         isSecondaryLabel: config.isSecondaryLabel)
        {
            HStack {
                CurrencyViewText(config)
                Spacer().frame(width: ExplainableColumnSize.width)
            }
        }
    }
}

enum CurrencyExplanation {
    case text(_ text: String)
    case taxInfo(_ tax: Tax)
    case deductionInfo(_ deduction: Deduction)
}

struct ExplainableCurrencyView: View {
    var config: CurrencyViewConfig
    var explanation: CurrencyExplanation

    init(_ config: CurrencyViewConfig, explanation: CurrencyExplanation) {
        self.config = config
        self.explanation = explanation
    }

    var body: some View {
        LabeledValueView(title: config.titleText,
                         subtitle: config.subtitle,
                         showSeparator: config.showSeparator,
                         isSecondaryLabel: config.isSecondaryLabel)
        {
            ExplainableView {
                CurrencyViewText(config)
            } infoContent: {
                Group {
                    switch explanation {
                        case let .text(text):
                            Text(text)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                        case let .taxInfo(tax):
                            TaxInfoView(tax)
                        case let .deductionInfo(deduction):
                            DeductionInfoView(deduction)
                    }
                }
                .navigationTitle(config.title)
            }
        }
    }
}

struct LabeledExplainableValueView: View {
    var titleText: String
    var valueText: String
    var infoText: String
    var showSeparator: Bool = true

    var body: some View {
        LabeledValueView(title: titleText,
                         subtitle: "",
                         showSeparator: showSeparator,
                         isSecondaryLabel: false)
        {
            ExplainableView {
                Text(valueText)
                    .font(.system(.body, design: .monospaced))
            } infoContent: {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Calculation:")
                        .font(.headline)
                    Text(infoText)
                        .font(.system(.body, design: .monospaced))
                }
                .padding(20.0)
                .navigationTitle(titleText)
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
                #if os(macOS)
                    titleLabel()
                #elseif os(iOS)
                    VStack(alignment: .leading) {
                        titleLabel()
                    }
                #endif

                Spacer(minLength: 20)

                valueView
            }
            .padding(.top, -0.5)
            .padding(.bottom, -0.5)
        }
    }

    @ViewBuilder
    func titleLabel() -> some View {
        Text(title)
            .foregroundColor(isSecondaryLabel ? .secondary : .primary)

        if subtitle.count > 0 {
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        TaxListGroupView {
            ExplainableCurrencyView(
                CurrencyViewConfig(title: "Alpha", amount: 123.53, showSeparator: false),
                explanation: .text("info")
            )
            CurrencyView(.secondaryAdditionConfig(title: "Beta", amount: 25.25))
            CurrencyView(.secondaryAdditionConfig(title: "Gamma", amount: -12.23))
            CurrencyView(.boldSumConfig(title: "Total", amount: 123.53 + 25.25))
            CurrencyView(CurrencyViewConfig(title: "PS", amount: -12.23))
            CurrencyView(CurrencyViewConfig(title: "PS", subtitle: "(some explanation)", amount: 0.0))
            CurrencyView(.secondaryAdditionConfig(title: "Gamma", amount: -0.0))
        }.padding()
    }
}
