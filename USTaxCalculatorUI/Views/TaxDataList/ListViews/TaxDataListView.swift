//
//

import SwiftUI

struct TaxDataListView: View {
    @ObservedObject var appState: GlobalAppState

    let taxdata: CalculatedTaxData

    var body: some View {
        TabView {
            TaxDataTabView(.federal) {
                FederalIncomeListSection(isExpanded: $appState.sectionCollapseState.income,
                                         taxdata: taxdata.federal,
                                         income: taxdata.income)
                FederalTaxesListSection(isExpanded: $appState.sectionCollapseState.federal,
                                        taxdata: taxdata.federal,
                                        summary: taxdata.taxSummaries.federal)
            }

            TaxDataTabView(.states) {
                ForEach(taxdata.stateTaxes.indices, id: \.self) { idx in
                    let stateTax = taxdata.stateTaxes[idx]
                    StateTaxesListSection(isExpanded: appState.stateCollapseStateBinding(for: stateTax.state),
                                          isFirst: idx == 0,
                                          totalIncome: taxdata.income.totalIncome,
                                          stateTax: stateTax,
                                          summary: taxdata.taxSummaries.states[stateTax.state])
                }
            }

            TaxDataTabView(.summary) {
                TaxSummaryListSection(taxdata: taxdata)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataListView(appState: GlobalAppState(),
                        taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(height: 650.0)
    }
}
