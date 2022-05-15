//
//

import SwiftUI

struct TaxDataListView: View {
    @ObservedObject var collapseState: SectionCollapseState
    @ObservedObject var appState: GlobalAppState

    let taxdata: CalculatedTaxData

    var body: some View {
        let _ = print("Evaluating TaxDataListView")

        ScrollView {
            VStack(alignment: .leading) {
                FederalIncomeListSection(isExpanded: $collapseState.income,
                                         taxdata: taxdata)
                FederalTaxesListSection(isExpanded: $collapseState.federal,
                                        taxdata: taxdata)

                ForEach(taxdata.stateTaxes) { stateTax in
                    StateTaxesListSection(isExpanded: collapseState.stateBinding(for: stateTax.state),
                                          totalIncome: taxdata.income.totalIncome,
                                          stateTax: stateTax,
                                          summary: taxdata.taxSummaries.states[stateTax.state])
                }

                TaxSummaryListSection(isExpanded: $collapseState.summary,
                                      taxdata: taxdata)
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
