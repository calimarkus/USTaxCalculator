//
// BracketTableView.swift
//

import SwiftUI

extension TaxBracket: Identifiable {
    var id: Double {
        startingAt
    }

    var isProgressive: Bool {
        switch type {
            case .basic:
                return false
            case .interpolated:
                return false
            case .progressive:
                return true
        }
    }
}

struct BracketHighlightView: View {
    var body: some View {
        Color.accentColor
            .opacity(0.33)
            .cornerRadius(6.0)
            .padding(-4.0)
            .padding([.leading, .trailing], -10.0)
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
                            BracketHighlightView()
                        }
                    }

                if let activeBracket {
                    if case let .interpolated(lower, _) = activeBracket.type, lower.startingAt == bracket.startingAt {
                        Spacer().frame(height: 8.0)
                        bracketRow(bracket: activeBracket)
                            .background {
                                BracketHighlightView()
                            }
                    }
                }
            }
        }
        .padding([.leading, .trailing], 10.0)
    }

    private var maxSmallColumnWidth: Double {
        isProgressive ? 120.0 : 240.0
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
                    if isProgressive, bracket.startingAt > 0.0 {
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

struct BracketTableView_Previews: PreviewProvider {
    static let fedBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2020_MarriedJointly.taxRates.federalRates.incomeRates)
    static let longtermGainsBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2020_MarriedJointly.taxRates.federalRates.longtermGainsRates)
    static let caliLowIncomeBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(TaxYear2020_MarriedJointly.taxRates.californiaRates.lowIncomeRates)

    static var previews: some View {
        BracketTableView(brackets: fedBrackets.sortedBrackets.reversed(), activeBracket: fedBrackets.sortedBrackets[3])
            .padding(.top, -20.0)
            .padding(20.0)

        BracketTableView(brackets: longtermGainsBrackets.sortedBrackets.reversed(), activeBracket: longtermGainsBrackets.sortedBrackets[1])
            .padding(.top, -20.0)
            .padding(20.0)

        BracketTableView(brackets: caliLowIncomeBrackets.sortedBrackets.reversed(), activeBracket: caliLowIncomeBrackets.matchingBracketFor(taxableIncome: 64800))
            .padding(.top, -20.0)
            .padding(20.0)
    }
}
