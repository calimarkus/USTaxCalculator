//
//

import SwiftUI

struct AddEntryButton: View {
    var appState: GlobalAppState

    var body: some View {
        Button {
            appState.navigationState = .addNewEntry
        } label: {
            Image(systemName: "plus")
                .help("Add Entry")
        }
    }
}

struct AddEntryButton_Previews: PreviewProvider {
    @State static var appState: GlobalAppState = .init()
    static var previews: some View {
        AddEntryButton(appState: appState)
            .padding()
    }
}
