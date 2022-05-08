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
    var includeCalculationExplanations: Bool = false
    var locale: Locale = .init(identifier: "en_US")

    func taxDataSummary(_ td: USTaxData) -> String {
        let income = td.income
        let taxSummaries = td.taxSummaries

        // output
        var summary = ""
        summary.appendLine(FormattingHelper.formattedTitle(taxData: td))
        summary.appendLine(String(repeating: "=", count: summary.count))

        // Federal
        summary.appendLine("\nFed Taxes:".uppercased())
        summary.appendLine(formattedCurrency("- Wages:", income.wages))
        summary.appendLine(formattedCurrency("", income.totalCapitalGains, "(capital gains)"))
        summary.appendLine(formattedCurrency("- Total Income:", income.totalIncome))
        if income.longtermCapitalGains > 0 {
            summary.appendLine(formattedCurrency("", -income.longtermCapitalGains, "(longterm gains)"))
        }
        summary.appendLine(formattedCurrency("", -td.federalDeductions, "(deductions)"))
        summary.appendLine(formattedCurrency("- Taxable Income:", td.taxableFederalIncome))

        summary.appendLine()
        summary.appendLine("- Federal Taxes:")
        if taxSummaries.federal.credits > 0 {
            summary.appendLine(formattedCurrency("  - Federal Credits:", -taxSummaries.federal.credits))
        }
        for fedTax in td.allFederalTaxes {
            summary.appendLine(formattedCurrency("  - \(fedTax.title) Tax:", fedTax.taxAmount, includeCalculationExplanations ? formattedExplanation(fedTax) : ""))
            summary.appendLine(formattedBracketRate("    Rate:", fedTax.bracket))
        }

        summary.appendLine(formattedSumSeparator())
        summary.appendLine(formattedTaxSummary(taxSummaries.federal, title: "Fed"))

        // States
        summary.appendLine("\nState Taxes:".uppercased())

        for stateTax in td.stateTaxes {
            let credit = td.stateCredits[stateTax.state] ?? 0.0
            summary.appendLine("- \(stateTax.state) (at \(FormattingHelper.formatPercentage(stateTax.incomeRate, locale: locale)))")
            summary.appendLine(formattedCurrency("  Deductions:", -stateTax.deductions))
            summary.appendLine(formattedCurrency("  Taxable Income:", stateTax.taxableIncome))
            if credit > 0 {
                summary.appendLine(formattedCurrency("  - State Credits:", -credit))
            }
            summary.appendLine(formattedCurrency("  - State Tax:", stateTax.stateOnlyTaxAmount, includeCalculationExplanations ? formattedExplanation(stateTax) : ""))
            summary.appendLine(formattedBracketRate("    Rate:", stateTax.bracket))
            if let localTax = stateTax.localTax {
                summary.appendLine(formattedCurrency("  - Local Tax (\(localTax.city)):", localTax.taxAmount, includeCalculationExplanations ? formattedExplanation(localTax) : ""))
                summary.appendLine(formattedBracketRate("    Local Rate:", localTax.bracket))
                summary.appendLine(formattedCurrency("  - Total:", stateTax.taxAmount - credit))
            }
            summary.appendLine(formattedCurrency("", -stateTax.withholdings, "(withheld)"))
            summary.appendLine(formattedCurrency("  To Pay:", stateTax.taxAmount - stateTax.withholdings - credit))
        }

        summary.appendLine(formattedSumSeparator())
        summary.appendLine(formattedTaxSummary(taxSummaries.states, title: "State Total"))

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

    func formattedRate(_ title: String, _ rate: Double, appendix: String = "") -> String {
        return alignLeftRight(title, FormattingHelper.formatPercentage(rate, locale: locale), appendix, shift: 1)
    }

    func formattedBracketRate(_ title: String, _ bracket: TaxBracket) -> String {
        return formattedRate(title, bracket.rate, appendix: "(\(FormattingHelper.formattedBracketStart(bracket, locale: locale)))")
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
        output.appendLine(formattedCurrency("", -summary.withholdings, "(withheld)"))
        output.appendLine(formattedCurrency("- To Pay (\(title)):", summary.outstandingPayment))
        output.appendLine(formattedRate("  ->", summary.effectiveTaxRate, appendix: "(effective)"))
        return output
    }
}
