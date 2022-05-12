//
//

import SwiftUI

struct TaxDataListView: View {
    @ObservedObject var collapseState: SectionCollapseState
    @ObservedObject var appState: GlobalAppState

    let taxdata: CalculatedTaxData

    var body: some View {
        List {
            FederalIncomeListSection(collapseState: collapseState,
                                     taxdata: taxdata)
            FederalTaxesListSection(collapseState: collapseState,
                                    taxdata: taxdata)
            ForEach(taxdata.stateTaxes) { stateTax in
                StateTaxesListSection(collapseState: collapseState,
                                      totalIncome: taxdata.income.totalIncome,
                                      stateTax: stateTax,
                                      stateCredits: taxdata.stateCredits[stateTax.state] ?? 0.0)
            }
            if taxdata.stateTaxes.count > 1 {
                CollapsableSection(title: "States Total") { _ in
                    TaxSummaryView(summary: taxdata.taxSummaries.states)
                }
            }
            CollapsableSection(title: "Total") { _ in
                TaxSummaryView(summary: taxdata.taxSummaries.total)
            }
        }
        .navigationTitle(FormattingHelper.formattedTitle(taxdata: taxdata))
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
                    appState.navigationState = .addNewEntry
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
                        appState: GlobalAppState(),
                        taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(width: 600.0, height: 1200.0)
    }
}
