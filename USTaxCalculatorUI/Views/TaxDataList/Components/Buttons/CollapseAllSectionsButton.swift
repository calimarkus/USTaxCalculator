//
//

import SwiftUI

struct CollapseAllSectionsButton: View {
    let allStates: [TaxState]
    @ObservedObject var collapseState: SectionCollapseState

    var body: some View {
        Button {
            withAnimation {
                collapseState.toggleAll(allStates: allStates)
            }
        } label: {
            Image(systemName: collapseState.isAllCollapsed ? "rectangle.expand.vertical" : "rectangle.compress.vertical")
                .help(collapseState.isAllCollapsed ? "Expand all" : "Collapse all")
        }
    }
}

struct CollapseAllSectionsButton_Previews: PreviewProvider {
    static var previews: some View {
        CollapseAllSectionsButton(allStates: [.CA, .NY],
                                  collapseState: SectionCollapseState())
            .padding()
    }
}
