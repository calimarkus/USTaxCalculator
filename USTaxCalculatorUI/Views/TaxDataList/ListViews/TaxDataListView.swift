//
//

import SwiftUI

struct TaxDataListView: View {
    @ObservedObject var collapseState: SectionCollapseState
    @ObservedObject var appState: GlobalAppState

    let taxdata: CalculatedTaxData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                FederalIncomeListSection(collapseState: collapseState,
                                         taxdata: taxdata)
                FederalTaxesListSection(collapseState: collapseState,
                                        taxdata: taxdata)
                ForEach(taxdata.stateTaxes) { stateTax in
                    StateTaxesListSection(collapseState: collapseState,
                                          totalIncome: taxdata.income.totalIncome,
                                          stateTax: stateTax,
                                          summary: taxdata.taxSummaries.states[stateTax.state],
                                          stateCredits: taxdata.stateCredits[stateTax.state] ?? 0.0)
                }

                CollapsableSection(title: "Total", expandedBinding: $collapseState.summary) { expanded in
                    if taxdata.stateTaxes.count > 1 {
                        TaxListGroupView {
                            TaxSummaryView(title: FormattingHelper.formattedStates(states: taxdata.stateTaxes.map { $0.state }),
                                           summary: taxdata.taxSummaries.stateTotal,
                                           expanded: expanded)
                        }
                    }
                    TaxListGroupView {
                        TaxSummaryView(summary: taxdata.taxSummaries.total, expanded: expanded)
                    }
                }
            }.padding()
        }
        .navigationTitle(FormattingHelper.formattedTitle(taxdata: taxdata))
        .toolbar {
            ToolbarItem(placement: .status) {
                ExportAsTextButton(taxdata: taxdata)
            }
            ToolbarItem(placement: .status) {
                CollapseAllSectionsButton(allStates: taxdata.stateTaxes.map { $0.state },
                                          collapseState: collapseState)
            }
            ToolbarItem(placement: .status) {
                AddEntryButton(appState: appState)
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
