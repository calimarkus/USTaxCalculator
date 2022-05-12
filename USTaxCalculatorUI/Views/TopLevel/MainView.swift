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
                switch appState.navigationState {
                    case .empty:
                        EmptyView(appState: appState)
                    case .addNewEntry:
                        TaxDataEntryView(title: "New Entry",
                                         appState: appState)
                    case .entry(let entryIndex, let isEditing):
                        if isEditing {
                            TaxDataEntryView(title: "Editing",
                                             appState: appState,
                                             input: appState.taxdata[entryIndex].input)
                        } else if appState.taxdata.count > entryIndex {
                            TaxDataListView(collapseState: collapseState,
                                            appState: appState,
                                            taxdata: appState.taxdata[entryIndex])
                        }
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
