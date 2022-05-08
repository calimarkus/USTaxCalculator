//
//

import SwiftUI

struct IncomeInput {
    /// Wages as listed on W-2, Box 1
    var wages: String = ""
    /// Medicare Wages as listed on W-2, Box 5
    var medicareWages: String = ""
    /// Federal Income Tax Withheld as listed on W-2, Box 2
    var federalWithholdings: String = ""

    /// Any Interests & Dividends (e.g. from Bank Accounts, Investments) as listed on 1099-INT, 1099-DIV
    var dividendsAndInterests: String = ""
    /// Capital Gains excluding dividends and interests (e.g. from Investments) - as listed on e.g. 1099-B
    var capitalGains: String = ""
    /// Longterm Gains as listed on e.g. 1099-B (these are taxed lower than shortterm gains)
    var longtermCapitalGains: String = ""
}

struct IncomeEntryView: View {
    @State var income: IncomeInput = .init()
    @State var stateIncomes: [StateIncomeInput] = [StateIncomeInput()]

    var body: some View {
        ScrollView {
            Form {
                Section(header: Text("W-2 Income").fontWeight(.bold)) {
                    TextField("Wages (Box 1)", text: $income.wages)
                    TextField("Federal Withholdings (Box 2)", text: $income.federalWithholdings)
                    TextField("Medicare Wages (Box 5)", text: $income.medicareWages)
                }

                Section(header: Text("Investment Income").fontWeight(.bold)) {
                    TextField("Dividends and Interest (Forms 1099-INT, 1099-DIV)", text: $income.dividendsAndInterests)
                    TextField("Capital Gains (Form 1099-B)", text: $income.capitalGains)
                    TextField("Longterm Capital Gains (Form 1099-B)", text: $income.longtermCapitalGains)
                }

                ForEach(0 ..< stateIncomes.count, id: \.self) { i in
                    StateIncomeEntryView(income: $stateIncomes[i])
                }

                Button("Add State") {
                    stateIncomes.append(StateIncomeInput())
                }
                Button("Save") {}
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
