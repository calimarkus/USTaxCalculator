//
//

import SwiftUI

struct MainView: View {
    @Binding var document: TaxDataDocument

    @ObservedObject var appState: GlobalAppState
    @ObservedObject var collapseState: SectionCollapseState

    var body: some View {
        Group {
            if appState.isEditing {
                TaxDataEntryView(appState: appState,
                                 input: $document.taxDataInput)
            } else {
                let taxdata = try! CalculatedTaxData(document.taxDataInput)
                TaxDataListView(collapseState: collapseState,
                                appState: appState,
                                taxdata: taxdata)
            }
        }
        .frame(minWidth: 500.0, minHeight: 500.0)
        .toolbar {
            ToolbarItemGroup {
                if !appState.isEditing {
                    ExportAsTextButton(taxDataInput: $document.taxDataInput)
                }

                Button {
                    appState.isEditing.toggle()
                } label: {
                    if appState.isEditing {
                        Text("Done")
                    } else {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var document: TaxDataDocument = .init()
    static var previews: some View {
        MainView(document: $document,
                 appState: GlobalAppState(),
                 collapseState: SectionCollapseState())
    }
}
