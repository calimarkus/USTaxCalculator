//
//

import SwiftUI

struct TaxDataView: View {

    let taxdata:USTaxData

    var body: some View {
        List {
            FederalIncomeListSection(taxdata: taxdata)
            FederalTaxesListSection(taxdata: taxdata)
            StateTaxesListSection(taxdata: taxdata)
            Section(header: Text("Total")) {
                TaxSummaryView(summary: taxdata.taxSummaries.total)
            }
        }
        .navigationTitle(FormattingHelper.formattedTitle(taxData: taxdata))
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .frame(minWidth: 600.0, minHeight: 400.0)
        .environment(\.defaultMinListRowHeight, 0)
        .environment(\.defaultMinListHeaderHeight, 30)
        .toolbar {
            ToolbarItem(placement: .status) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataView(taxdata: TaxDataSet().activeTaxData)
            .frame(width: 600.0, height: 1200.0)

    }
}
