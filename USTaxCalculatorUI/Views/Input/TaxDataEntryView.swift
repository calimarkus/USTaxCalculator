//
//

import SwiftUI

struct TaxDataEntryView: View {
    @State var income: Income = .init()
    @State var stateIncomes: [StateIncomeInput] = []

    var body: some View {
        VStack(spacing: 0.0) {
            ZStack {
                Color.secondary
                    .opacity(0.25)
                    .frame(height: 44.0)
                Text("New Tax Data")
                    .font(.title3)
                    .bold()
            }
            Color.secondary
                .frame(height: 1.0)
                .opacity(0.5)
            ScrollView {
                Form {
                    FederalTaxDataEntryView(income: $income)

                    ForEach(0 ..< stateIncomes.count, id: \.self) { i in
                        StateTaxDataEntryView(incomeInput: $stateIncomes[i]) {
                            stateIncomes.remove(at: i)
                        }
                    }

                    HStack {
                        Button("Add State") {
                            stateIncomes.append(StateIncomeInput())
                        }
                        Spacer()
                        Button("Save") {
                            var merged = income
                            merged.stateIncomes = stateIncomes.map { $0.income }
                            print(merged)
                        }
                    }
                }
                .padding()
            }
            .frame(minWidth: 500, minHeight: 400)
        }
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataEntryView()
    }
}
