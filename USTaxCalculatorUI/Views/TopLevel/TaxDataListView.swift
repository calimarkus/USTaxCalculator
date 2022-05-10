//
//

import SwiftUI

struct TaxDataListView: View {
    @ObservedObject var collapseState: SectionCollapseState
    @ObservedObject var dataset: TaxDataSet

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
        .environment(\.defaultMinListHeaderHeight, 30)
        .toolbar {
            ToolbarItem(placement: .status) {
                ExportAsTextButton(taxdata: taxdata)
            }
            ToolbarItem(placement: .status) {
                CollapseAllSectionsButton(allStates: taxdata.stateTaxes.map { $0.state },
                                          collapseState: collapseState)
            }
            ToolbarItem(placement: .status) {
                Button {
                    dataset.addNewEntry()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataListView(collapseState: SectionCollapseState(),
                        dataset: TaxDataSet(),
                        taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(width: 600.0, height: 1200.0)
    }
}
