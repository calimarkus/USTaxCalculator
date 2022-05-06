//
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {

    @StateObject private var modelData = TaxDataSet()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(modelData)
        }
    }
}
