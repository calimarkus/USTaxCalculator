//
//

import Foundation

struct TaxSummaryFormatter {
    let columnWidth:Int
    let separatorSize:(width:Int,shift:Int)
    let printCalculationExplanations:Bool
    let locale:Locale?

    func printTaxDataSummary(_ td:USTaxData) {
        let income = td.income
        let taxSummaries = td.taxSummaries

        // output
        let title = FormattingHelper.formattedTitle(taxData: td)
        print(title)
        print(String(repeating:"=", count:title.count))

        // Federal
        print("\nFed Taxes:".uppercased())
        printCurrency("- Wages:", income.wages)
        printCurrency("", income.totalCapitalGains, "(capital gains)")
        printCurrency("- Total Income:", income.totalIncome)
        if income.longtermCapitalGains > 0 {
            printCurrency("", -income.longtermCapitalGains, "(longterm gains)")
        }
        printCurrency("", -td.federalDeductions, "(deductions)")
        printCurrency("- Taxable Income:", td.taxableFederalIncome)

        print("")
        print("- Federal Taxes:")
        if taxSummaries.federal.credits > 0 {
            printCurrency("  - Federal Credits:", -taxSummaries.federal.credits)
        }
        for fedTax in td.allFederalTaxes {
            printCurrency("  - \(fedTax.title) Tax:", fedTax.taxAmount, FormattingHelper.formatExplanation(fedTax, explanationsEnabled: printCalculationExplanations))
            printBracketRate("    Rate:", fedTax.bracket)
        }

        printSumSeparator()
        printTaxSummary(taxSummaries.federal, title: "Fed")

        // States
        print("\nState Taxes:".uppercased())

        for stateTax in td.stateTaxes {
            let credit = td.stateCredits[stateTax.state] ?? 0.0
            print("- \(stateTax.state) (at \(FormattingHelper.formatPercentage(stateTax.incomeRate, locale: self.locale)))")
            printCurrency("  Deductions:", -stateTax.deductions)
            printCurrency("  Taxable Income:", stateTax.taxableIncome)
            if credit > 0 {
                printCurrency("  - State Credits:", -credit)
            }
            printCurrency("  - State Tax:", stateTax.stateOnlyTaxAmount, FormattingHelper.formatExplanation(stateTax, explanationsEnabled: printCalculationExplanations))
            printBracketRate("    Rate:", stateTax.bracket)
            if let localTax = stateTax.localTax {
                printCurrency("  - Local Tax (\(localTax.city)):", localTax.taxAmount, FormattingHelper.formatExplanation(localTax, explanationsEnabled: printCalculationExplanations))
                printBracketRate("    Local Rate:", localTax.bracket)
                printCurrency("  - Total:", stateTax.taxAmount - credit)
            }
            printCurrency("", -stateTax.withholdings, "(withheld)")
            printCurrency("  To Pay:", stateTax.taxAmount - stateTax.withholdings - credit)
        }

        printSumSeparator()
        printTaxSummary(taxSummaries.states, title: "State Total")

        // Summary
        print("\nSummary:".uppercased())
        printCurrency("- Income:", income.totalIncome)
        printTaxSummary(taxSummaries.total, title: "Total")
    }

}

// printing helpers
private extension TaxSummaryFormatter {
    func alignLeftRight(_ left:String, _ right:String, _ appendix:String="", shift:Int=0) -> String {
        let spacing = String(repeating: " ", count: max(1, self.columnWidth+shift - left.count - right.count))
        return "\(left)\(spacing)\(right) \(appendix)"
    }
    func printCurrency(_ title:String, _ num:Double, _ appendix:String="") {
        print(alignLeftRight(title, FormattingHelper.formatCurrency(num, locale: self.locale), appendix))
    }
    func printRate(_ title:String, _ rate:Double, appendix:String="") {
        print(alignLeftRight(title, FormattingHelper.formatPercentage(rate, locale: self.locale), appendix, shift:1))
    }
    func printBracketRate(_ title:String, _ bracket:TaxBracket) {
        printRate(title, bracket.rate, appendix:"(\(FormattingHelper.formattedBracketStart(bracket, locale: self.locale)))")
    }
    func printSumSeparator() {
        print(alignLeftRight("", String(repeating:"-", count:self.separatorSize.width), shift:self.separatorSize.shift))
    }
    func printTaxSummary(_ summary:TaxSummary, title:String) {
        printCurrency("- Total tax:", summary.taxes)
        printCurrency("", -summary.withholdings, "(withheld)")
        printCurrency("- To Pay (\(title)):", summary.outstandingPayment)
        printRate("  ->", summary.effectiveTaxRate, appendix: "(effective)")
    }
}
