//
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @StateObject private var modelData = TaxDataSet()
    @StateObject private var collapseState = SectionCollapseState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(modelData)
                .environmentObject(collapseState)
        }
    }
}
