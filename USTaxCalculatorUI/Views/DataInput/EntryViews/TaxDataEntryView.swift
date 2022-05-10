//
//

import SwiftUI

struct TaxDataEntryView: View {
    @State var input: TaxDataInput = .init(income: Income(stateIncomes: [StateIncome()]))

    var body: some View {
        TabView {
            FederalEntryTab(input: $input)
            StateEntryTab(input: $input)
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
            .frame(height: 640)
    }
}
