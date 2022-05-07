//
//

import SwiftUI

struct TaxDataView: View {
    let taxdata: USTaxData

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
        .environment(\.defaultMinListRowHeight, 0)
        .environment(\.defaultMinListHeaderHeight, 30)
        .toolbar {
            ToolbarItem(placement: .status) {
                ExportAsTextButton(taxdata: taxdata)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataView(taxdata: ExampleData.single21Data())
            .frame(width: 600.0, height: 1200.0)
    }
}
