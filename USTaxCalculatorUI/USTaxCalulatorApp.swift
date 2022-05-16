//
//

import SwiftUI

@main
struct USTaxCalulatorApp: App {
    @ObservedObject private var appState = GlobalAppState()
    @ObservedObject private var collapseState = SectionCollapseState()

    var body: some Scene {
        DocumentGroup(newDocument: TaxDataDocument(), editor: { file in
            TaxDataListView(collapseState: collapseState,
                            appState: appState,
                            taxdata: try! CalculatedTaxData(file.document.taxDataInput))
        })
    }
}
