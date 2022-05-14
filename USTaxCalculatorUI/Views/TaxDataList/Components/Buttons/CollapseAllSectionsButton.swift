//
//

import SwiftUI

struct CollapseAllSectionsButton: View {
    let allStates: [TaxState]
    @ObservedObject var collapseState: SectionCollapseState

    var isCollapsed: Bool {
        !collapseState.income
    }

    var body: some View {
        Button {
            withAnimation {
                let collapsed = isCollapsed
                collapseState.income = collapsed
                collapseState.federal = collapsed
                for state in allStates {
                    collapseState.states[state] = collapsed
                }
            }
        } label: {
            Image(systemName: isCollapsed ? "rectangle.expand.vertical" : "rectangle.compress.vertical")
                .help(isCollapsed ? "Expand all" : "Collapse all")
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
