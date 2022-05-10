//
//

import SwiftUI

struct TaxDataEntryView: View {
    @State var input: TaxDataInput = .init()

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
                    FederalTaxDataEntryView(income: $input.income)

                    ForEach(0 ..< input.income.stateIncomes.count, id: \.self) { i in
                        StateTaxDataEntryView(income: $input.income.stateIncomes[i]) {
                            input.income.stateIncomes.remove(at: i)
                        }
                    }

                    HStack {
                        Button("Add State") {
                            input.income.stateIncomes.append(StateIncome())
                        }
                        Spacer()
                        Button("Save") {
                            dump(input)
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
