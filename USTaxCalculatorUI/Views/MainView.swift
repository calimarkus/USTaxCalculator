//
//

import SwiftUI

class SectionCollapseState: ObservableObject {
    @Published var income: Bool = true
    @Published var federal: Bool = true
    @Published var states: [TaxState: Bool] = [:]

    func stateBinding(for state: TaxState) -> Binding<Bool> {
        return Binding(get: {
            self.states[state, default: true]
        }, set: {
            self.states[state] = $0
        })
    }
}

class TaxDataSet: ObservableObject {
    @Published var selection: Set<Int> = [0]

    var activeTaxData: USTaxData? {
        if let idx = selection.first {
            return taxData[idx]
        } else {
            return nil
        }
    }

    let taxData: [USTaxData] = [ExampleData.exampleTaxDataJohnAndSarah_21(),
                                ExampleData.exampleTaxDataJackHouston_21(),
                                ExampleData.exampleTaxDataJackHouston_20()]
}

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
