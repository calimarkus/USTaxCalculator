//
//

import SwiftUI

struct EmptyView: View {
    var appState: GlobalAppState

    var body: some View {
        VStack(spacing: 0.0) {
            Text("Nothing selected")
                .padding(10.0)
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .opacity(0.5)
            Button {
                appState.navigationState = .addNewEntry
            } label: {
                Text("Add a new entry")
            }.padding()
        }
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .status) {
                AddEntryButton(appState: appState)
            }
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(appState: .init())
            .padding()
    }
}
