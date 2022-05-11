//
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @StateObject private var appState = GlobalAppState()
    @StateObject private var collapseState = SectionCollapseState()

    var body: some Scene {
        WindowGroup {
            MainView(appState: appState,
                     collapseState: collapseState)
        }
    }
}
