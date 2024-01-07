//
// StateTitleButton.swift
//

import SwiftUI
import TaxModels

struct StateTitleButton: View {
    @Binding var stateIncome: StateIncome
    let showRemoveButton: Bool
    let onRemove: () -> Void

    var body: some View {
        let buttonTitle = "\(stateIncome.state) Taxes"
        let titleView = Text(buttonTitle).fontWeight(.bold)
        if showRemoveButton {
            Button {
                onRemove()
            } label: {
                Image(systemName: "minus.circle.fill")
                titleView
            }
            #if os(macOS)
            .buttonStyle(.plain)
            #endif
        } else {
            titleView
        }
    }
}

struct StateTitleButton_Previews: PreviewProvider {
    @State static var stateIncome: StateIncome = .init()

    static var previews: some View {
        VStack(alignment: .leading) {
            StateTitleButton(stateIncome: $stateIncome,
                             showRemoveButton: false) {}
            StateTitleButton(stateIncome: $stateIncome,
                             showRemoveButton: true) {}
        }.padding()
    }
}
