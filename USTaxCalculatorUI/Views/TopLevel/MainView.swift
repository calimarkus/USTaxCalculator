//
//

import SwiftUI

struct MainView: View {
    @ObservedObject var dataset: TaxDataSet
    @ObservedObject var collapseState: SectionCollapseState
    @State var showIncomeEntryPopover: Bool = false

    var body: some View {
        NavigationView {
            MenuView(dataset: dataset)
            Group {
                if let taxdata = dataset.activeTaxData {
                    TaxDataView(collapseState: collapseState,
                                taxdata: taxdata)
                } else {
                    EmptyView(showIncomeEntryPopover: $showIncomeEntryPopover)
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
                                                  collapseState:collapseState)
                    }
                }
                ToolbarItem(placement: .status) {
                    Button {
                        showIncomeEntryPopover.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }.popover(isPresented: $showIncomeEntryPopover) {
                        IncomeEntryView()
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
