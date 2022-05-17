//
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @ObservedObject private var appState = GlobalAppState()
    @ObservedObject private var collapseState = SectionCollapseState()

    var body: some Scene {
        DocumentGroup(newDocument: TaxDataDocument(), editor: { file in
            MainView(document: file.$document,
                     appState: appState,
                     collapseState: collapseState)
        })
    }
}
