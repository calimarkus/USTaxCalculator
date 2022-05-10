//
//

import SwiftUI

struct TaxDataEntryView: View {
    @State var input: TaxDataInput = .init()

    var body: some View {
        VStack(spacing: 0.0) {
            EntryViewTitle(
                title: "New Tax Data",
                onSave: {
                    dump(input)
                },
                onAddState: {
                    input.income.stateIncomes.append(StateIncome())
                })
            ScrollView {
                Form {
                    BasicTaxDataEntryView(input: $input)
                    FederalTaxDataEntryView(income: $input.income)

                    // states
                    ForEach(input.income.stateIncomes.indices, id: \.self) { i in
                        StateTaxDataEntryView(income: $input.income.stateIncomes[i], idx: i) {
                            input.income.stateIncomes.remove(at: i)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataEntryView()
    }
}
