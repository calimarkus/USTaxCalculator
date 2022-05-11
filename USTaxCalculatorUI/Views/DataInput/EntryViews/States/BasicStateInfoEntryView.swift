//
//

import SwiftUI

struct BasicStateInfoEntryView: View {
    @Binding var stateIncome: StateIncome

    var body: some View {
        Picker("State", selection: $stateIncome.state) {
            Text("CA").tag(TaxState.CA)
            Text("NY").tag(TaxState.NY)
        }.frame(maxWidth: 180)

        Picker("Local Tax", selection: $stateIncome.localTax) {
            Text("None").tag(LocalTaxType.none)
            Text("NYC").tag(LocalTaxType.city(.NYC))
        }.frame(maxWidth: 180)
    }
}

struct BasicStateInfoEntryView_Previews: PreviewProvider {
    @State static var stateIncome: StateIncome = .init()
    static var previews: some View {
        Form {
            BasicStateInfoEntryView(stateIncome: $stateIncome)
        }.padding()
    }
}
