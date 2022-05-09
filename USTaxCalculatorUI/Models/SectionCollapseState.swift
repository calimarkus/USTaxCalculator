//
//

import SwiftUI

class SectionCollapseState: ObservableObject {
    @Published var income: Bool = true
    @Published var federal: Bool = true
    @Published var states: [TaxState: Bool] = [:]

    func stateBinding(for state: TaxState) -> Binding<Bool> {
        return Binding(get: {
            self.states[state, default: true]
        }, set: {
            self.states[state] = $0
        })
    }
}
