//
//

import SwiftUI

struct IncomeEntryView: View {
    @State var income: Income = .init()
    @State var stateIncomes: [StateIncomeInput] = []

    var body: some View {
        ScrollView {
            Form {
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

                ForEach(0 ..< stateIncomes.count, id: \.self) { i in
                    StateIncomeEntryView(incomeInput: $stateIncomes[i])
                }

                Button("Add State") {
                    stateIncomes.append(StateIncomeInput())
                }
                Button("Save") {
                    var merged = income
                    merged.stateIncomes = stateIncomes.map { $0.income }
                    print(merged)
                }
            }
            .padding()
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct IncomeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeEntryView()
            .frame(height: 600.0)
    }
}
