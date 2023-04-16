//
// BracketInfoView.swift
//

import SwiftUI

extension TaxBracket: Identifiable {
    var id: Double {
        startingAt
    }
}

extension TaxBracket {
    var isProgressive: Bool {
        switch type {
            case .progressive:
                return true
            case .basic:
                return false
        }
    }
}

enum BracketInfoSize {
    static let smallColumnMaxWidth = 120.0
    static let columnSpacing = 20.0
    static let minWidth = 500.0
}

struct BracketInfoView: View {
    let brackets: [TaxBracket]
    let activeBracket: TaxBracket?
    let taxableIncome: NamedValue?

    init(bracketGroup: TaxBracketGroup,
         activeBracket: TaxBracket? = nil,
         taxableIncome: NamedValue? = nil)
    {
        brackets = bracketGroup.sortedBrackets.reversed()
        self.activeBracket = activeBracket
        self.taxableIncome = taxableIncome
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            if let active = activeBracket, let income = taxableIncome {
                VStack(alignment: .leading, spacing: 10.0) {
                    Text("Tax Calculation:")
                        .font(.headline)
                    Text("\(active.taxCalculationExplanation(income, explanationType: .names))")
                        .padding(.bottom, -4.0)
                        .foregroundColor(.secondary)
                    Text("\(active.taxCalculationExplanation(income)) = \(FormattingHelper.formatCurrency(active.calculateTaxesForAmount(income)))")
                        .font(.system(.body, design: .monospaced))
                        .padding(.bottom, 14.0)

                    Text("Tax Brackets:")
                        .font(.headline)
                    BracketTableView(brackets: brackets, activeBracket: activeBracket)
                }
            } else {
                BracketTableView(brackets: brackets, activeBracket: activeBracket)
            }
        }
        .padding(20.0)
        #if os(macOS)
            .frame(minWidth: BracketInfoSize.minWidth)
        #endif
    }
}

struct BracketTableView: View {
    let brackets: [TaxBracket]
    let activeBracket: TaxBracket?

    var isProgressive: Bool {
        brackets.last?.isProgressive ?? false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            titleRow

            ForEach(brackets) { bracket in
                Spacer().frame(height: 8.0)

                bracketRow(bracket: bracket)
                    .background {
                        if let activeBracket, activeBracket.startingAt == bracket.startingAt {
                            Color.accentColor
                                .opacity(0.33)
                                .cornerRadius(6.0)
                                .padding(-4.0)
                                .padding([.leading, .trailing], -10.0)
                        }
                    }
            }
        }
        .padding(10.0)
        .padding(.top, -10.0)
    }
}

extension BracketTableView {
    private var maxSmallColumnWidth: Double {
        isProgressive ? BracketInfoSize.smallColumnMaxWidth : BracketInfoSize.smallColumnMaxWidth * 2.0
    }

    private var titleRow: some View {
        HStack(spacing: 0.0) {
            HStack(spacing: 0.0) {
                Text("Starting at").font(.subheadline)
                Spacer()
            }.frame(width: maxSmallColumnWidth)

            if isProgressive {
                HStack(spacing: 0.0) {
                    Text("Fixed Amount").font(.subheadline)
                    Spacer()
                }.frame(maxWidth: maxSmallColumnWidth)
            }

            HStack(spacing: 0.0) {
                Text("Tax Rate").font(.subheadline)
                Spacer()
            }
        }
        .frame(height: 32.0)
        .background {
            Color.secondary
                .opacity(0.1)
                .padding([.leading, .trailing], -30)
        }
    }

    private func bracketRow(bracket: TaxBracket) -> some View {
        HStack(spacing: 0.0) {
            // starting at
            HStack(spacing: 0.0) {
                Text("\(FormattingHelper.formatCurrency(bracket.startingAt))")
                    .padding(.trailing, 7.0)
                Spacer()
            }.frame(width: maxSmallColumnWidth)

            // fixed amount
            if isProgressive {
                HStack(spacing: 0.0) {
                    Group {
                        if case let .progressive(amount) = bracket.type {
                            Text("\(FormattingHelper.formatCurrency(amount))")
                        } else {
                            Text("\(FormattingHelper.formatCurrency(0.0))")
                        }
                    }.padding(.trailing, 7.0)
                    Spacer()
                }.frame(maxWidth: maxSmallColumnWidth)
            }

            // rate
            HStack(spacing: 0.0) {
                Text("\(FormattingHelper.formatPercentage(bracket.rate))")

                #if os(macOS)
                    if bracket.isProgressive, bracket.startingAt > 0.0 {
                        Text("of amount over \(FormattingHelper.formatCurrency(bracket.startingAt))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading, 6.0)
                    }
                #endif

                Spacer()
            }
        }
    }
}

struct BracketInfoView_Previews: PreviewProvider {
    static let fedBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2021_Single.taxRates.federalRates.incomeRates)
    static let longtermGainsBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2021_Single.taxRates.federalRates.longtermGainsRates)

    static var previews: some View {
        BracketInfoView(
            bracketGroup: fedBrackets,
            activeBracket: fedBrackets.sortedBrackets[3],
            taxableIncome: NamedValue(amount: 92720, name: "Preview Income")
        )

        BracketInfoView(
            bracketGroup: longtermGainsBrackets,
            activeBracket: longtermGainsBrackets.sortedBrackets[1],
            taxableIncome: NamedValue(amount: 246_000, name: "Preview Income")
        )

        BracketInfoView(
            bracketGroup: longtermGainsBrackets
        )
    }
}
