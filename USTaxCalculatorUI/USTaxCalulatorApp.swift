//
// USTaxCalulatorApp.swift
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @ObservedObject private var appState = GlobalAppState()

    var body: some Scene {
        DocumentGroup(newDocument: TaxDataDocument(), editor: { file in
            MainView(document: file.$document,
                     appState: appState)
        })
    }
}
