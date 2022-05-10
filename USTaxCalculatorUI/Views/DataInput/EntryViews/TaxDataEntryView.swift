//
//

import SwiftUI

struct TaxDataEntryView: View {
    @ObservedObject var dataset: TaxDataSet
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
                    do {
                        let taxdata = try USTaxData(input)
                        dataset.taxData.append(taxdata)
                        dataset.selection = [dataset.taxData.count - 1]
                    } catch {
                        // TBD - handle invalid inputs
                    }
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct TaxDataEntryView_Previews: PreviewProvider {
    @State static var dataset: TaxDataSet = .init()
    static var previews: some View {
        TaxDataEntryView(dataset: dataset)
            .frame(height: 640)
    }
}
