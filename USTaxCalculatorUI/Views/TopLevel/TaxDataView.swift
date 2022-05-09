//
//

import SwiftUI

struct TaxDataView: View {
    @ObservedObject var collapseState: SectionCollapseState

    let taxdata: USTaxData

    var body: some View {
        List {
            FederalIncomeListSection(collapseState: collapseState,
                                     taxdata: taxdata)
            FederalTaxesListSection(collapseState: collapseState,
                                    taxdata: taxdata)
            ForEach(taxdata.stateTaxes) { stateTax in
                StateTaxesListSection(collapseState: collapseState,
                                      stateTax: stateTax,
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataView(collapseState: SectionCollapseState(),
                    taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(width: 600.0, height: 1200.0)
    }
}
