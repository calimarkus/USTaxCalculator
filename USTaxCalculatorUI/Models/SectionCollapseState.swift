//
//

import SwiftUI

class SectionCollapseState: ObservableObject {
    @Published var income: Bool = true
    @Published var federal: Bool = true
    @Published var summary: Bool = true
    @Published var states: [TaxState: Bool] = [:]

    func stateBinding(for state: TaxState) -> Binding<Bool> {
        return Binding(get: {
            self.states[state, default: true]
        }, set: {
            self.states[state] = $0
        })
    }

    var isAllCollapsed: Bool {
        !income
    }

    func toggleAll(allStates: [TaxState]) {
        let collapsed = isAllCollapsed
        income = collapsed
        federal = collapsed
        summary = collapsed
        for state in allStates {
            states[state] = collapsed
        }
    }
}
