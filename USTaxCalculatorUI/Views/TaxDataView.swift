//
//

import SwiftUI

struct TaxDataView: View {
    let taxdata: USTaxData

    var body: some View {
        List {
            FederalIncomeListSection(taxdata: taxdata)
            FederalTaxesListSection(taxdata: taxdata)
            ForEach(taxdata.stateTaxes) { stateTax in
                StateTaxesListSection(stateTax: stateTax,
                                      stateCredits: taxdata.stateCredits[stateTax.state] ?? 0.0)
            }
            if taxdata.stateTaxes.count > 1 {
                Section(header: Text("States Total")) {
                    TaxSummaryView(summary: taxdata.taxSummaries.states)
                }
            }
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
        TaxDataView(taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(width: 600.0, height: 1200.0)
    }
}
