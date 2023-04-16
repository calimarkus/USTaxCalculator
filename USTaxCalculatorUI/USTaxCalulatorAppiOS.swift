//
// USTaxCalulatorAppiOS.swift
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @ObservedObject private var appState = GlobalAppState()
    @ObservedObject private var localTaxDataState = LocalTaxDataState()

    var body: some Scene {
        WindowGroup {
            MenuViewiOS(appState: appState, localTaxDataState: localTaxDataState)
        }
    }
}
