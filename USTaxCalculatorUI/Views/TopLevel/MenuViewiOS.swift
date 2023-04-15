//
//

import SwiftUI

struct MenuViewiOS: View {
    @ObservedObject var appState: GlobalAppState
    @ObservedObject var localTaxDataState: LocalTaxDataState
    @State var navPath: [NavigationTarget] = []

    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                Section {
                    ForEach(localTaxDataState.taxdatas) { taxdata in
                        NavigationLink(value: NavigationTarget(taxdata: taxdata)) {
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
                            let data = localTaxDataState.addEntry()
                            navPath = [NavigationTarget(taxdata: data),
                                       NavigationTarget(taxdata: data, isEditing: true)]
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
            .navigationDestination(for: NavigationTarget.self) { target in
                if !target.isEditing {
                    TaxDataListView(appState: appState, taxdata: target.taxdata)
                        .navigationTitle(target.taxdata.formattedTitle())
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem {
                                NavigationLink(value: NavigationTarget(taxdata: target.taxdata, isEditing: true)) {
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                        }
                } else {
                    TaxDataEntryView(appState: appState, taxdataId: target.taxdata.id, input: target.taxdata.inputData) { taxDataId, taxInput in
                        if let data = localTaxDataState.replaceTaxData(id: taxDataId, input: taxInput) {
                            navPath = [NavigationTarget(taxdata: data)]
                        }
                    }
                    .navigationTitle(target.taxdata.formattedTitle())
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuViewiOS(appState: GlobalAppState(),
                    localTaxDataState: LocalTaxDataState())
    }
}
