//
//

import Foundation

extension String {
    mutating func appendLine(_ string: String = "") {
        self += string + "\n"
    }

    mutating func appendTitle(_ string: String = "") {
        self += "\n====  " + string.uppercased() + "  ====\n\n"
    }
}

struct TaxSummaryFormatter {
    let columnWidth: Int
    let separatorSize: (width: Int, shift: Int)
    var locale: Locale = .init(identifier: "en_US")

    func federalSummary(income: Income, taxData: FederalTaxData, taxSummary: TaxSummary) -> String {
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
        summary.appendLine(formattedCurrency("", -taxData.deductions, "(deductions)"))
        summary.appendLine(formattedCurrency("- Taxable Income:", taxData.taxableIncome))

        summary.appendLine()
        summary.appendLine("- Taxes:")

        for fedTax in taxData.taxes {
            summary.appendLine(formattedCurrency("  - \(fedTax.title) Tax:", fedTax.taxAmount))
            summary.appendLine(formattedBracketRate("    ", fedTax.bracket))
        }

        if taxData.credits > 0 {
            summary.appendLine(formattedCurrency("  - Tax Credits:", -taxData.credits))
        }

        summary.appendLine(formattedSumSeparator())
        summary.append(formattedTaxSummary(taxSummary, title: "Fed"))

        return summary
    }

    func stateSummary(income: Income,
                      stateTaxes: [StateTax],
                      taxSummaries: [TaxState: TaxSummary]) -> String
    {
        var summary = ""
        summary.appendTitle("State Taxes")

        for stateTax in stateTaxes {
            let credit = stateTax.credits
            summary.appendLine("- \(stateTax.state)")
            summary.appendLine(formattedCurrency("  Total Income:", income.totalIncome))
            summary.appendLine(formattedCurrency("  Deductions:", -stateTax.deductions))
            summary.appendLine(formattedCurrency("  Taxable Income:", stateTax.taxableIncome.amount))

            if stateTax.incomeRate < 1.0 {
                summary.appendLine(formattedCurrency("  - State Attributed Income:", stateTax.stateAttributedIncome))
                summary.appendLine(alignLeftRight("  - State Income Rate:", formattedRate(stateTax.incomeRate)))
            }

            summary.appendLine(formattedCurrency("  - State Tax:", stateTax.stateOnlyTaxAmount))
            summary.appendLine(formattedBracketRate("    ", stateTax.bracket))

            if let localTax = stateTax.localTax {
                summary.appendLine(formattedCurrency("  - Local Tax (\(localTax.city)):", localTax.taxAmount))
                summary.appendLine(formattedBracketRate("    ", localTax.bracket))
            }

            if credit > 0 {
                summary.appendLine(formattedCurrency("  - Tax Credits:", -credit))
            }

            if let taxSummary = taxSummaries[stateTax.state] {
                summary.appendLine(formattedSumSeparator())
                summary.append(formattedTaxSummary(taxSummary, title: "\(stateTax.state)"))
            }

            summary.appendLine()
        }

        return summary
    }

    func taxDataSummary(_ td: CalculatedTaxData) -> String {
        let income = td.income
        let taxSummaries = td.taxSummaries

        // output
        var summary = ""
        if td.title.count > 0 {
            summary.appendLine(td.title.uppercased())
        }
        summary.appendLine(FormattingHelper.formattedTitle(taxdata: td).uppercased())
        summary.appendLine(String(repeating: "=", count: summary.count))

        // Federal
        summary.append(federalSummary(income: income, taxData: td.federal, taxSummary: td.taxSummaries.federal))

        // States
        summary.append(stateSummary(income: income, stateTaxes: td.stateTaxes, taxSummaries: td.taxSummaries.states))

        // State Summary
        if income.stateIncomes.count > 0 {
            summary.appendTitle("State Summary (\(FormattingHelper.formattedStates(states: income.stateIncomes.map { $0.state })))")
            summary.append(formattedTaxSummary(taxSummaries.stateTotal))
        }

        // Summary
        summary.appendTitle("Summary")
        summary.appendLine(formattedCurrency("- Total Income:", income.totalIncome))
        summary.appendLine()
        summary.append(formattedTaxSummary(taxSummaries.total))

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

    func formattedBracketRate(_ prefix: String, _ bracket: TaxBracket) -> String {
        return prefix + formattedRate(bracket.rate)
    }

    func formattedSumSeparator() -> String {
        return alignLeftRight("", String(repeating: "-", count: separatorSize.width), shift: separatorSize.shift)
    }

    func formattedExplanation(_ tax: Tax) -> String {
        return String(repeating: " ", count: 15) + "Math: \(tax.bracket.taxCalculationExplanation(tax.taxableIncome))"
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
