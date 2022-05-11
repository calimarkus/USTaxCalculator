//
//

import SwiftUI

struct StateEntryTab: View {
    @Binding var input: TaxDataInput

    var body: some View {
        ScrollView {
            Form {
                ForEach(input.income.stateIncomes.indices, id: \.self) { i in
                    StateIncomeEntryView(input: $input,
                                         stateIncome: $input.income.stateIncomes[i],
                                         idx: i)
                }
                Button {
                    input.income.stateIncomes.append(StateIncome())
                } label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Add State")
                        .fontWeight(.bold)
                }
                .buttonStyle(.plain)
                .padding(.top, 10.0)
            }
            .frame(maxWidth: 500)
            .padding()
        }
    }
}

struct StateEntryTab_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .emptyInput()

    static var previews: some View {
        StateEntryTab(input: $input)
            .padding()
            .frame(height: 600)
    }
}
