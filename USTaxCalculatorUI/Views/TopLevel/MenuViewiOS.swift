//
//

import SwiftUI

struct MenuViewiOS: View {
    @ObservedObject var appState: GlobalAppState
    @ObservedObject var localTaxDataState: LocalTaxDataState

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(localTaxDataState.taxdatas) { taxdata in
                        NavigationLink {
                            EditableTaxDataView(appState: appState,
                                                localTaxDataState: localTaxDataState,
                                                taxdata: taxdata)
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                VStack(alignment: .leading) {
                                    if taxdata.title.count > 0 {
                                        Text(taxdata.title)
                                        Text(FormattingHelper.formattedTitle(taxdata: taxdata))
                                            .font(.footnote)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text(FormattingHelper.formattedTitle(taxdata: taxdata))
                                    }
                                }
                            }
                        }
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            localTaxDataState.taxdatas.remove(at: index)
                        }
                    }
                }
                Section {
                    Button {
                        withAnimation {
                            localTaxDataState.addEntry()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Entry")
                        }
                    }
                }
            }
            .navigationTitle("Entries")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuViewiOS(appState: GlobalAppState(),
                    localTaxDataState: LocalTaxDataState())
    }
}
