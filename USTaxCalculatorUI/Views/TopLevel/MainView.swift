//
//

import SwiftUI

struct MainView: View {
    @ObservedObject var appState: GlobalAppState
    @ObservedObject var collapseState: SectionCollapseState

    var body: some View {
        NavigationView {
            MenuView(appState: appState)
            Group {
                if appState.showEntryForm {
                    TaxDataEntryView(appState: appState,
                                     input: appState.taxDataInputForEditing)
                } else if let taxdata = appState.activeTaxData {
                    TaxDataListView(collapseState: collapseState,
                                    appState: appState,
                                    taxdata: taxdata)
                } else {
                    EmptyView(appState: appState)
                }
            }
            .frame(minWidth: 400.0, minHeight: 400.0)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(appState: GlobalAppState(),
                 collapseState: SectionCollapseState())
            .frame(width: 750.0, height: 500)
    }
}
