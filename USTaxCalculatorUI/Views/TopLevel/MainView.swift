//
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataset: TaxDataSet
    @EnvironmentObject var collapseState: SectionCollapseState
    @State var showIncomeEntryPopover: Bool = false

    var body: some View {
        NavigationView {
            MenuView()
            Group {
                if let taxdata = dataset.activeTaxData {
                    TaxDataView(taxdata: taxdata)
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
                        Button {
                            withAnimation {
                                let newState = !collapseState.income
                                collapseState.income = newState
                                collapseState.federal = newState
                                for i in 0 ..< collapseState.states.count {
                                    collapseState.states[taxdata.stateTaxes[i].state] = newState
                                }
                            }
                        } label: {
                            Image(systemName: "rectangle.expand.vertical")
                        }
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
        MainView()
            .frame(width: 750.0, height: 500)
            .environmentObject(TaxDataSet())
    }
}
