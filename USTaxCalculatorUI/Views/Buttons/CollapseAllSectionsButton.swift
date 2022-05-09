//
//

import SwiftUI

struct CollapseAllSectionsButton: View {
    let allStates: [TaxState]
    @ObservedObject var collapseState: SectionCollapseState

    var body: some View {
        Button {
            withAnimation {
                let collapsed = !collapseState.income
                collapseState.income = collapsed
                collapseState.federal = collapsed
                for state in allStates {
                    collapseState.states[state] = collapsed
                }
            }
        } label: {
            Image(systemName: "rectangle.expand.vertical")
        }
    }
}

struct CollapseAllSectionsButton_Previews: PreviewProvider {
    static var previews: some View {
        CollapseAllSectionsButton(allStates: [.CA, .NY],
                                  collapseState:SectionCollapseState())
            .padding()
    }
}
