//
//

import SwiftUI

struct EditableTaxDataView: View {
    @ObservedObject var appState: GlobalAppState
    @ObservedObject var localTaxDataState: LocalTaxDataState
    var taxdata: CalculatedTaxData

    var body: some View {
        Group {
            if appState.isEditing, let binding = localTaxDataState.editingInputBinding() {
                TaxDataEntryView(appState: appState, input: binding)
            } else {
                TaxDataListView(appState: appState, taxdata: taxdata)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(taxdata.title.count > 0 ? taxdata.title : FormattingHelper.formattedTitle(taxdata: taxdata))
        .toolbar {
            ToolbarItem {
                EditButton(isEditing: $appState.isEditing)
            }
        }
        .onChange(of: appState.isEditing) { isEditing in
            if isEditing {
                localTaxDataState.editingInput = taxdata.input
            } else {
                localTaxDataState.updateTaxDataWithEditingInput(taxdata: taxdata)
                localTaxDataState.editingInput = nil
            }
        }
    }
}

struct EditableTaxDataView_Previews: PreviewProvider {
    static var previews: some View {
        EditableTaxDataView(appState: GlobalAppState(),
                            localTaxDataState: LocalTaxDataState(),
                            taxdata: try! CalculatedTaxData(.emptyInput()))
    }
}
