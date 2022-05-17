//
//

import SwiftUI

struct TaxDataListView: View {
    @ObservedObject var collapseState: SectionCollapseState
    @ObservedObject var appState: GlobalAppState

    let taxdata: CalculatedTaxData

    var body: some View {
        TabView {
            TaxDataTabView(.federal) {
                FederalIncomeListSection(isExpanded: $collapseState.income,
                                         taxdata: taxdata.federal,
                                         income: taxdata.income)
                FederalTaxesListSection(isExpanded: $collapseState.federal,
                                        taxdata: taxdata.federal,
                                        summary: taxdata.taxSummaries.federal)
            }

            TaxDataTabView(.states) {
                ForEach(taxdata.stateTaxes.indices, id: \.self) { idx in
                    let stateTax = taxdata.stateTaxes[idx]
                    StateTaxesListSection(isExpanded: collapseState.stateBinding(for: stateTax.state),
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
        TaxDataListView(collapseState: SectionCollapseState(),
                        appState: GlobalAppState(),
                        taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(height: 650.0)
    }
}
