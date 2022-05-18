//
//

import SwiftUI

struct SectionCollapseState {
    var income: Bool = true
    var federal: Bool = true
    var states: [TaxState: Bool] = [:]
}

class GlobalAppState: ObservableObject {
    @Published var isEditing: Bool = false
    @Published var sectionCollapseState = SectionCollapseState()

    func stateCollapseStateBinding(for state: TaxState) -> Binding<Bool> {
        return Binding(get: {
            self.sectionCollapseState.states[state, default: true]
        }, set: {
            self.sectionCollapseState.states[state] = $0
        })
    }
}
