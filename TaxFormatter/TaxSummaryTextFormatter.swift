//
// TaxSummaryTextFormatter.swift
//

import Foundation
import TaxOutputModels
import TaxIncomeModels

extension String {
    mutating func appendLine(_ string: String = "") {
        self += string + "\n"
    }

    mutating func appendTitle(_ string: String = "") {
        self += "\n====  " + string.uppercased() + "  ====\n\n"
    }
}

public struct TaxSummaryTextFormatter {
    public let columnWidth: Int
    public let separatorSize: (width: Int, shift: Int)
    public var locale: Locale = .init(identifier: "en_US")

    public init(columnWidth: Int, separatorSize: (width: Int, shift: Int), locale: Locale = .init(identifier: "en_US")) {
        self.columnWidth = columnWidth
        self.separatorSize = separatorSize
        self.locale = locale
    }

    public func taxDataSummary(_ td: CalculatedTaxData) -> String {
        // output
        var summary = ""
        summary.appendLine(td.formattedTitle.uppercased())
        if let subtitle = td.formattedSubtitle {
            summary.appendLine(subtitle.uppercased())
        }
        summary.appendLine(String(repeating: "=", count: summary.count))

        // Federal
        summary.append(federalSummary(income: td.income, taxData: td.federalData, taxSummary: td.federalData.summary))

        // States
        summary.append(stateSummary(income: td.income, stateTaxDatas: td.stateTaxDatas))

        // State Summary
        if td.income.stateIncomes.count > 0 {
            summary.appendTitle("State Summary (\(FormattingHelper.formattedStates(states: td.income.stateIncomes.map(\.state))))")
            summary.append(formattedTaxSummary(td.statesSummary))
        }

        // Summary
        summary.appendTitle("Summary")
        summary.appendLine(formattedCurrency("- Total Income:", td.income.totalIncome))
        summary.appendLine()
        summary.append(formattedTaxSummary(td.totalSummary))

        return summary
    }

    private func federalSummary(income: Income, taxData: FederalTaxData, taxSummary: TaxSummary) -> String {
        var summary = ""

        summary.appendTitle("Federal Taxes")

        summary.appendLine(formattedCurrency("- Wages:", income.wages))
        if income.capitalGains > 0.0 {
            summary.appendLine(formattedCurrency("- Capital Gains:", income.totalCapitalGains))
            summary.appendLine(formattedCurrency("- Total Income:", income.totalIncome))
        }
        if income.longtermCapitalGains > 0 {
            summary.appendLine(formattedCurrency("", -income.longtermCapitalGains, "(longterm gains)"))
        }
        summary.appendLine(formattedCurrency("", -taxData.deduction.amount, "(deduction)"))
        summary.appendLine(formattedCurrency("- Taxable Income:", taxData.totalTaxableIncome))

        summary.appendLine()
        summary.appendLine("- Taxes:")

        for fedTax in taxData.taxes {
            summary.appendLine(formattedCurrency("  - \(fedTax.title) Tax:", fedTax.taxAmount))
            summary.appendLine(formattedBracketRate("    ", fedTax.activeBracket))
        }

        if taxData.credits > 0 {
            summary.appendLine(formattedCurrency("  - Tax Credits:", -taxData.credits))
        }

        summary.appendLine(formattedSumSeparator())
        summary.append(formattedTaxSummary(taxSummary, title: "Fed"))

        return summary
    }

    private func stateSummary(income: Income, stateTaxDatas: [StateTaxData]) -> String {
        var summary = ""
        summary.appendTitle("State Taxes")

        for stateTaxData in stateTaxDatas {
            summary.appendLine("- \(stateTaxData.state)")
            summary.appendLine(formattedCurrency("  Total Income:", income.totalIncome))
            summary.appendLine(formattedCurrency("  Deduction:", -stateTaxData.deduction.amount))
            summary.appendLine(formattedCurrency("  Taxable Income:", stateTaxData.taxableStateIncome.amount))

            if stateTaxData.attributableIncome.rate.amount < 1.0 {
                summary.appendLine(formattedCurrency("  - \(stateTaxData.attributableIncome.incomeName):", stateTaxData.attributableIncome.amount))
                summary.appendLine(alignLeftRight("  - \(stateTaxData.attributableIncome.rate.name):", formattedRate(stateTaxData.attributableIncome.rate.amount)))
            }

            for stateTax in stateTaxData.taxes {
                summary.appendLine(formattedCurrency("  - \(stateTax.title) Tax:", stateTax.taxAmount))
                summary.appendLine(formattedBracketRate("    ", stateTax.activeBracket))
            }

            if let localTax = stateTaxData.localTax {
                summary.appendLine(formattedCurrency("  - \(localTax.title) Tax:", localTax.taxAmount))
                summary.appendLine(formattedBracketRate("    ", localTax.activeBracket))
            }

            if stateTaxData.credits > 0 {
                summary.appendLine(formattedCurrency("  - Tax Credits:", -stateTaxData.credits))
            }

            summary.appendLine(formattedSumSeparator())
            summary.append(formattedTaxSummary(stateTaxData.summary, title: "\(stateTaxData.state)"))

            summary.appendLine()
        }

        return summary
    }
}

// printing helpers
private extension TaxSummaryTextFormatter {
    func alignLeftRight(_ left: String, _ right: String, _ appendix: String = "", shift: Int = 0) -> String {
        let spacing = String(repeating: " ", count: max(1, columnWidth + shift - left.count - right.count))
        return "\(left)\(spacing)\(right) \(appendix)"
    }

    func formattedCurrency(_ title: String, _ num: Double, _ appendix: String = "") -> String {
        alignLeftRight(title, FormattingHelper.formatCurrency(num, locale: locale), appendix)
    }

    func formattedRate(_ rate: Double) -> String {
        FormattingHelper.formatPercentage(rate, locale: locale)
    }

    func formattedBracketRate(_ prefix: String, _ bracket: TaxBracket) -> String {
        prefix + formattedRate(bracket.rate)
    }

    func formattedSumSeparator() -> String {
        alignLeftRight("", String(repeating: "-", count: separatorSize.width), shift: separatorSize.shift)
    }

    func formattedExplanation(_ tax: any Tax) -> String {
        String(repeating: " ", count: 15) + "Math: \(tax.activeBracket.taxCalculationExplanation(for: tax.taxableIncome))"
    }

    func formattedTaxSummary(_ summary: TaxSummary, title: String = "") -> String {
        var output = ""
        output.appendLine(formattedCurrency("- Total tax:", summary.taxes))
        output.appendLine("  " + formattedRate(summary.effectiveTaxRate) + " (effective)")
        output.appendLine(formattedCurrency("", -summary.withholdings, "(withheld)"))

        let paymentTitle = summary.outstandingPayment < 0 ? "Tax Refund" : "To Pay"
        let titleString = title.count > 0 ? " (\(title))" : ""
        output.appendLine(formattedCurrency("- \(paymentTitle)\(titleString):", summary.outstandingPayment))
        return output
    }
}
