//
// MainView.swift
//

import SwiftUI
import TaxCalculator

struct MainView: View {
    @Binding var document: TaxDataDocument

    @ObservedObject var appState: GlobalAppState

    var body: some View {
        Group {
            if appState.isEditing {
                TaxDataEntryView(appState: appState,
                                 input: $document.taxDataInput)
            } else {
                let taxdata = TaxCalculator.calculateTaxesForInput(document.taxDataInput)
                TaxDataListView(appState: appState,
                                taxdata: taxdata)
            }
        }
        #if os(macOS)
        .frame(minWidth: 500.0, minHeight: 500.0)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: toolbarPlacement) {
                if !appState.isEditing {
                    ExportAsTextButton(taxDataInput: $document.taxDataInput)
                }

                EditButton(isEditing: $appState.isEditing)
            }
        }
    }

    var toolbarPlacement: ToolbarItemPlacement {
        #if os(macOS)
            return .automatic
        #else
            return .navigationBarTrailing
        #endif
    }
}

struct MainView_Previews: PreviewProvider {
    @State static var document: TaxDataDocument = .init()
    static var previews: some View {
        MainView(document: $document,
                 appState: GlobalAppState())
    }
}
