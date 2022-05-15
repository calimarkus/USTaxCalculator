//
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @ObservedObject private var appState = GlobalAppState()
    @ObservedObject private var collapseState = SectionCollapseState()

    var body: some Scene {
        WindowGroup {
            MainView(appState: appState,
                     collapseState: collapseState)
        }
    }
}
