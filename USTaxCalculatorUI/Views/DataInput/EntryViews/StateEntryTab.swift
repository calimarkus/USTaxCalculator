//
//

import SwiftUI

struct StateEntryTab: View {
    @Binding var input: TaxDataInput

    var body: some View {
        ScrollView {
            Form {
                ForEach(input.income.stateIncomes.indices, id: \.self) { i in
                    StateTaxDataEntryView(income: $input.income.stateIncomes[i], idx: i) {
                        input.income.stateIncomes.remove(at: i)
                    }
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
            .padding()
        }
        .tabItem {
            Text("State Income")
        }
    }
}

struct StateEntryTab_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .emptyInput()

    static var previews: some View {
        TabView {
            StateEntryTab(input: $input)
        }
        .padding()
        .frame(height: 640.0)
    }
}
