//
// TaxDataListView.swift
//

import SwiftUI
import TaxOutputModels

struct TaxDataListView: View {
    @ObservedObject var appState: GlobalAppState

    let taxdata: CalculatedTaxData

    var body: some View {
        TabView {
            TaxDataTabView(.federal) {
                FederalIncomeListSection(isExpanded: $appState.sectionCollapseState.income,
                                         taxdata: taxdata.federalData,
                                         income: taxdata.income)
                FederalTaxesListSection(isExpanded: $appState.sectionCollapseState.federal,
                                        taxdata: taxdata.federalData)
            }

            TaxDataTabView(.states) {
                ForEach(taxdata.stateTaxDatas.indices, id: \.self) { idx in
                    let stateTaxData = taxdata.stateTaxDatas[idx]
                    StateTaxesListSection(isExpanded: appState.stateCollapseStateBinding(for: stateTaxData.state),
                                          isFirst: idx == 0,
                                          totalIncome: taxdata.totalIncome,
                                          stateTaxData: stateTaxData)
                }
            }

            TaxDataTabView(.summary) {
                TaxSummaryListSection(taxdata: taxdata)
            }
        }
        .macOnlyPadding(16.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaxDataListView(appState: GlobalAppState(),
                        taxdata: ExampleData.exampleTaxDataJohnAndSarah_21())
            .frame(height: 650.0)
    }
}
