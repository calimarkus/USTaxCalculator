//
//

import SwiftUI

struct FederalIncomeEntryView: View {
    @Binding var income: Income

    var body: some View {
        Section(header: Text("W-2 Income").fontWeight(.bold)) {
            CurrencyValueInputView(caption: "Wages",
                                   subtitle: " (W-2, Box 1)",
                                   amount: $income.wages)
            CurrencyValueInputView(caption: "Medicare Wages",
                                   subtitle: " (W-2, Box 5)",
                                   amount: $income.medicareWages)
            CurrencyValueInputView(caption: "Federal Withholdings",
                                   subtitle: " (W-2, Box 2)",
                                   amount: $income.federalWithholdings)
        }

        Section(header: Text("Investment Income").fontWeight(.bold)) {
            CurrencyValueInputView(caption: "Dividends & Interests",
                                   subtitle: "(Forms 1099-INT, 1099-DIV)",
                                   amount: $income.dividendsAndInterests)
            CurrencyValueInputView(caption: "Capital Gains",
                                   subtitle: "(Form 1099-B)",
                                   amount: $income.capitalGains)
            CurrencyValueInputView(caption: "Longterm Capital Gains",
                                   subtitle: "(Form 1099-B)",
                                   amount: $income.longtermCapitalGains)
        }
    }
}

struct FederalIncomeEntryView_Previews: PreviewProvider {
    @State static var income: Income = .init()
    static var previews: some View {
        Form {
            FederalIncomeEntryView(income: $income)
        }
        .padding()
    }
}
