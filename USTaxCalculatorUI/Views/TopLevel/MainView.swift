//
//

import SwiftUI

struct MainView: View {
    @ObservedObject var dataset: TaxDataSet
    @ObservedObject var collapseState: SectionCollapseState

    var body: some View {
        NavigationView {
            MenuView(dataset: dataset)
            Group {
                if dataset.showEntryForm {
                    TaxDataEntryView()
                } else if let taxdata = dataset.activeTaxData {
                    TaxDataListView(collapseState: collapseState,
                                    taxdata: taxdata)
                } else {
                    EmptyView(dataset: dataset)
                }
            }
            .frame(minWidth: 400.0, minHeight: 400.0)
            .toolbar {
                ToolbarItem(placement: .status) {
                    if let taxdata = dataset.activeTaxData {
                        ExportAsTextButton(taxdata: taxdata)
                    }
                }
                ToolbarItem(placement: .status) {
                    if let taxdata = dataset.activeTaxData {
                        CollapseAllSectionsButton(allStates: taxdata.stateTaxes.map { $0.state },
                                                  collapseState: collapseState)
                    }
                }
                ToolbarItem(placement: .status) {
                    Button {
//                        showIncomeEntryPopover.toggle()
                        dataset.showEntryForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(dataset: TaxDataSet(),
                 collapseState: SectionCollapseState())
            .frame(width: 750.0, height: 500)
    }
}
