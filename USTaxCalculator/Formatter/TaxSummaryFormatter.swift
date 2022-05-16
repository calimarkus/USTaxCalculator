//
//

import Foundation

extension String {
    mutating func appendLine(_ string: String = "") {
        self += string + "\n"
    }
}

struct TaxSummaryFormatter {
    let columnWidth: Int
    let separatorSize: (width: Int, shift: Int)
    var locale: Locale = .init(identifier: "en_US")

    func federalSummary(income: Income, taxData: FederalTaxData, taxSummary: TaxSummary) -> String {
        var summary = ""
        summary.appendLine("\nFederal Taxes:".uppercased())
        summary.appendLine(formattedCurrency("- Wages:", income.wages))
        if income.capitalGains > 0.0 {
            summary.appendLine(formattedCurrency("- Capital Gains:", income.totalCapitalGains))
            summary.appendLine(formattedCurrency("- Total Income:", income.totalIncome))
        }
        if income.longtermCapitalGains > 0 {
            summary.appendLine(formattedCurrency("", -income.longtermCapitalGains, "(longterm gains)"))
        }
        summary.appendLine(formattedCurrency("", -taxData.deductions, "(deductions)"))
        summary.appendLine(formattedCurrency("- Taxable Income:", taxData.taxableIncome))

        summary.appendLine()
        summary.appendLine("- Federal Taxes:")

        for fedTax in taxData.taxes {
            summary.appendLine(formattedCurrency("  - \(fedTax.title) Tax:", fedTax.taxAmount))
            summary.appendLine(formattedBracketRate("    ", fedTax.bracket))
        }

        summary.appendLine(formattedSumSeparator())
        summary.appendLine(formattedTaxSummary(taxSummary, title: "Fed"))

        return summary
    }

    func stateSummary(income: Income,
                      stateTaxes: [StateTax],
                      stateCredits: [TaxState: Double],
                      taxSummary: TaxSummary) -> String {
        var summary = ""
        summary.appendLine("\nState Taxes:".uppercased())

        for stateTax in stateTaxes {
            let credit = stateCredits[stateTax.state] ?? 0.0
            summary.appendLine("- \(stateTax.state) (at \(FormattingHelper.formatPercentage(stateTax.incomeRate, locale: locale)))")
            summary.appendLine(formattedCurrency("  Deductions:", -stateTax.deductions))
            summary.appendLine(formattedCurrency("  Taxable Income:", stateTax.taxableIncome))
            if credit > 0 {
                summary.appendLine(formattedCurrency("  - State Credits:", -credit))
            }
            summary.appendLine(formattedCurrency("  - State Tax:", stateTax.stateOnlyTaxAmount))
            summary.appendLine(formattedBracketRate("    ", stateTax.bracket))
            if let localTax = stateTax.localTax {
                summary.appendLine(formattedCurrency("  - Local Tax (\(localTax.city)):", localTax.taxAmount))
                summary.appendLine(formattedBracketRate("    ", localTax.bracket))
                summary.appendLine(formattedCurrency("  - Total:", stateTax.taxAmount - credit))
            }
            summary.appendLine(formattedCurrency("", -stateTax.withholdings, "(withheld)"))
            summary.appendLine(formattedCurrency("  To Pay:", stateTax.taxAmount - stateTax.withholdings - credit))
        }

        summary.appendLine(formattedSumSeparator())
        summary.appendLine(formattedTaxSummary(taxSummary, title: "State Total"))

        return summary
    }

    func taxDataSummary(_ td: CalculatedTaxData) -> String {
        let income = td.income
        let taxSummaries = td.taxSummaries

        // output
        var summary = ""
        summary.appendLine(FormattingHelper.formattedTitle(taxdata: td))
        summary.appendLine(String(repeating: "=", count: summary.count))

        // Federal
        summary.appendLine(federalSummary(income: income, taxData: td.federal, taxSummary: td.taxSummaries.federal))

        // States
        summary.appendLine(stateSummary(income: income, stateTaxes: td.stateTaxes, stateCredits: td.stateCredits, taxSummary: td.taxSummaries.stateTotal))

        // Summary
        summary.appendLine("\nSummary:".uppercased())
        summary.appendLine(formattedCurrency("- Income:", income.totalIncome))
        summary.appendLine(formattedTaxSummary(taxSummaries.total, title: "Total"))

        return summary
    }
}

// printing helpers
private extension TaxSummaryFormatter {
    func alignLeftRight(_ left: String, _ right: String, _ appendix: String = "", shift: Int = 0) -> String {
        let spacing = String(repeating: " ", count: max(1, columnWidth + shift - left.count - right.count))
        return "\(left)\(spacing)\(right) \(appendix)"
    }

    func formattedCurrency(_ title: String, _ num: Double, _ appendix: String = "") -> String {
        return alignLeftRight(title, FormattingHelper.formatCurrency(num, locale: locale), appendix)
    }

    func formattedRate(_ rate: Double) -> String {
        return FormattingHelper.formatPercentage(rate, locale: locale)
    }

    func formattedBracketRate(_ prefix:String, _ bracket: TaxBracket) -> String {
        return prefix + formattedRate(bracket.rate)
    }

    func formattedSumSeparator() -> String {
        return alignLeftRight("", String(repeating: "-", count: separatorSize.width), shift: separatorSize.shift)
    }

    func formattedExplanation(_ tax: Tax) -> String {
        return String(repeating: " ", count: 15) + "Math: \(tax.bracket.taxCalculationExplanation(tax.taxableIncome))"
    }

    func formattedTaxSummary(_ summary: TaxSummary, title: String) -> String {
        var output = ""
        output.appendLine(formattedCurrency("- Total tax:", summary.taxes))
        output.appendLine("  " + formattedRate(summary.effectiveTaxRate) + " (effective)")
        if summary.credits > 0 {
            output.appendLine(formattedCurrency("", -summary.credits, "(credits)"))
        }
        output.appendLine(formattedCurrency("", -summary.withholdings, "(withheld)"))
        output.appendLine(formattedCurrency("- To Pay (\(title)):", summary.outstandingPayment))
        return output
    }
}
