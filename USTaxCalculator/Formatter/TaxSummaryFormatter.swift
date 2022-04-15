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
        let title = formattedTitle(taxData: td)
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
        print("- Taxes:")
        if taxSummaries.federal.credits > 0 {
            printCurrency("  - Tax Credits:", -taxSummaries.federal.credits)
        }
        for fedTax in td.allFederalTaxes {
            printCurrency("  - \(fedTax.title) Tax:", fedTax.taxAmount, formatExplanation(fedTax, explanationsEnabled: printCalculationExplanations))
            printBracketRate("    Rate:", fedTax.bracket)
        }

        printSumSeparator()
        printTaxSummary(taxSummaries.federal, title: "Fed")

        // States
        print("\nState Taxes:".uppercased())
        if taxSummaries.states.credits > 0 {
            printCurrency("- Tax Credits:", -taxSummaries.states.credits)
        }

        for stateTax in td.stateTaxes {
            print("- \(stateTax.state) (at \(formatPercentage(stateTax.incomeRate)))")
            printCurrency("  Deductions:", -stateTax.deductions)
            printCurrency("  Taxable Income:", stateTax.taxableIncome)
            printBracketRate("  Rate:", stateTax.bracket)
            printCurrency("  Taxes:", stateTax.taxAmount, formatExplanation(stateTax, explanationsEnabled: printCalculationExplanations))
            printCurrency("", -stateTax.withholdings, "(withheld)")
            printCurrency("  To Pay:", stateTax.taxAmount - stateTax.withholdings)
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
    func printCurrency(_ title:String, _ num:Double, _ appendix:String="") {
        print(alignLeftRight(title, formatCurrency(num), appendix))
    }
    func printRate(_ title:String, _ rate:Double, appendix:String="") {
        print(alignLeftRight(title, formatPercentage(rate), appendix, shift:1))
    }
    func printBracketRate(_ title:String, _ bracket:TaxBracket) {
        printRate(title, bracket.rate, appendix:"(\(formattedBracketStart(bracket)))")
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

// formatting helpers
private extension TaxSummaryFormatter {
    func formattedTitle(taxData:USTaxData) -> String {
        var additionalTitle = ""
        if let t = taxData.title { additionalTitle = "\(t) - " }
        let statesString = taxData.stateTaxes.map { return "\($0.state)" }.joined(separator: "+")
        let title = "\(additionalTitle)Year \(taxData.taxYear.rawValue) (\(taxData.filingType.rawValue), \(statesString))"
        return title.uppercased()
    }

    func alignLeftRight(_ left:String, _ right:String, _ appendix:String="", shift:Int=0) -> String {
        let spacing = String(repeating: " ", count: max(1, self.columnWidth+shift - left.count - right.count))
        return "\(left)\(spacing)\(right) \(appendix)"
    }

    func formatExplanation(_ explanationProvider:ExplainableTaxAmountProvider, explanationsEnabled:Bool) -> String {
        return (explanationsEnabled
                ? String(repeating: " ", count: 15) + "Math: \(explanationProvider.taxCalculationExplanation)"
                : "")
    }

    func formatCurrency(_ num:Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.locale
        formatter.maximumFractionDigits = 0
        formatter.roundingMode = num >= 0 ? .ceiling : .floor
        return formatter.string(from: num as NSNumber)!
    }

    func formatPercentage(_ rate:Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = self.locale
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1

        return formatter.string(from: rate as NSNumber)!
    }

    func formattedBracketStart(_ bracket:TaxBracket) -> String {
        var val = bracket.startingAt / 1000.0
        var symbol = "K"
        if val > 1000.0 {
            val /= 1000.0
            symbol = "M"
        }
        return "\(formatCurrency(val))\(symbol)+"
    }
}
