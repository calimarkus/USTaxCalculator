//
//

import SwiftUI

struct TaxDataEntryView: View {
    @State var input: TaxDataInput = .init(income: Income(stateIncomes:[StateIncome()]))

    var body: some View {
        TabView {
            ScrollView {
                Form {
                    BasicTaxDataEntryView(input: $input)
                    FederalTaxDataEntryView(income: $input.income)
                }
                .padding()
            }
            .tabItem {
                Text("Federal Income")
            }

            ScrollView {
                Form {
                    Button {
                        input.income.stateIncomes.append(StateIncome())
                    } label: {
                        Text("Add State")
                    }
                    ForEach(input.income.stateIncomes.indices, id: \.self) { i in
                        StateTaxDataEntryView(income: $input.income.stateIncomes[i], idx: i) {
                            input.income.stateIncomes.remove(at: i)
                        }
                    }
                }
                .padding()
            }
            .tabItem {
                Text("State Income")
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
        .navigationTitle("New Entry: \(FormattingHelper.formattedTitle(taxDataInput: input))")
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {
                    dump(input)
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataEntryView()
    }
}
