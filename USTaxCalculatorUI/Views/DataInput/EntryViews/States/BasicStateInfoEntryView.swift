//
// BasicStateInfoEntryView.swift
//

import SwiftUI
import TaxModels

struct BasicStateInfoEntryView<HeaderContent: View>: View {
    @Binding var stateIncome: StateIncome
    var header: HeaderContent

    init(stateIncome: Binding<StateIncome>,
         @ViewBuilder headerContent: () -> HeaderContent)
    {
        _stateIncome = stateIncome
        header = headerContent()
    }

    var body: some View {
        Section(header: header) {
            Picker("State", selection: $stateIncome.state) {
                Text("CA").tag(TaxState.CA)
                Text("NY").tag(TaxState.NY)
            }
            #if os(macOS)
            .frame(maxWidth: 180)
            #endif

            Picker("Local Tax", selection: $stateIncome.localTax) {
                Text("None").tag(LocalTaxType.none)
                Text("NYC").tag(LocalTaxType.city(.NYC))
            }
            #if os(macOS)
            .frame(maxWidth: 180)
            #endif
        }
    }
}

struct BasicStateInfoEntryView_Previews: PreviewProvider {
    @State static var stateIncome = StateIncome(state: .CA)
    static var previews: some View {
        Form {
            BasicStateInfoEntryView(stateIncome: $stateIncome) {
                Text("Title").bold()
            }
        }.macOnlyPadding(30.0)
    }
}
