//
// BracketTableView.swift
//

import SwiftUI
import TaxOutputModels
import TaxRates
import TaxCalculator
import TaxFormatter

extension TaxBracket: Identifiable {
    public var id: Double {
        startingAt
    }

    var isProgressive: Bool {
        if case .progressive = type {
            return true
        }
        return false
    }

    var isInterpolated: Bool {
        if case .interpolated = type {
            return true
        }
        return false
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

    private var isProgressive: Bool {
        brackets.last?.isProgressive ?? false
    }

    private func isActiveBracket(_ bracket: TaxBracket) -> Bool {
        guard let activeBracket else {
            return false
        }
        return activeBracket.startingAt == bracket.startingAt
    }

    private func shouldInsertInterpolatedActiveBracket(_ bracket: TaxBracket, _ activeBracket: TaxBracket) -> Bool {
        if case let .interpolated(lower, _) = activeBracket.type, lower.startingAt == bracket.startingAt {
            return true
        }
        return false
    }

    var body: some View {
        VStack(spacing: 0.0) {
            titleRow

            ForEach(brackets) { bracket in
                Spacer().frame(height: 8.0)

                bracketRow(bracket: bracket)
                    .background {
                        if isActiveBracket(bracket) {
                            BracketHighlightView()
                        }
                    }

                if let activeBracket, shouldInsertInterpolatedActiveBracket(bracket, activeBracket) {
                    interpolatedBracketRow(activeBracket)
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
                    } else if bracket.isInterpolated {
                        Text("(interpolated)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading, 6.0)
                    }
                #endif

                Spacer()
            }
        }
    }

    private func interpolatedBracketRow(_ bracket: TaxBracket) -> some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .center) {
                Spacer().frame(width: maxSmallColumnWidth)
                Image(systemName: "ellipsis").padding(.leading, 8.0)
                Spacer()
            }
            .frame(height: 26.0)
            bracketRow(bracket: bracket)
                .background {
                    BracketHighlightView()
                }
            HStack(alignment: .center) {
                Spacer().frame(width: maxSmallColumnWidth)
                Image(systemName: "ellipsis").padding(.leading, 8.0)
                Spacer()
            }
            .frame(height: 26.0)
            .padding(.bottom, -10.0)
        }
    }
}

struct BracketTableView_Previews: PreviewProvider {
    static let ratesGroup = RawTaxRatesGroup.taxRatesGroup(for: .y2020, .marriedJointly)
    static let fedBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.federalRates.incomeRates)
    static let longtermGainsBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.federalRates.longtermGainsRates)
    static let caliLowIncomeBrackets = TaxBracketGenerator.bracketGroupForRawTaxRates(ratesGroup.rawStateTaxRates(for: .CA).incomeRates(forIncome: 60_000))

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
