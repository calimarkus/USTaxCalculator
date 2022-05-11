//
//

import SwiftUI

struct StateEntryTab: View {
    @Binding var input: TaxDataInput

    var body: some View {
        ScrollView {
            Form {
                ForEach(input.income.stateIncomes.indices, id: \.self) { i in
                    if i > 0 {
                        Spacer().frame(height: 20.0)
                    }

                    let stateIncome = $input.income.stateIncomes[i]
                    StateTitleButton(stateIncome: stateIncome,
                                     showRemoveButton: i > 0) {
                        input.income.stateIncomes.remove(at: i)
                    }
                    BasicStateInfoEntryView(stateIncome: stateIncome)
                    StateIncomeEntryView(stateIncome: stateIncome)
                    StateTaxReductionsEntryView(input: $input, stateIncome: stateIncome)
                }
                AddStateButton {
                    input.income.stateIncomes.append(StateIncome())
                }
            }
            .frame(maxWidth: 500)
            .padding()
        }
    }
}

struct StateEntryTab_Previews: PreviewProvider {
    @State static var input: TaxDataInput = TaxDataInput(income:Income(stateIncomes:[StateIncome(), StateIncome()]))

    static var previews: some View {
        StateEntryTab(input: $input)
            .padding()
            .frame(height: 900)
    }
}
