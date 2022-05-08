//
//

import SwiftUI

enum IncomeAmountInput {
    case fullFederal
    case partial
}

enum LocalTaxTypeInput {
    case none
    case nyc
}

struct StateIncomeInput {
    /// The state or city for this income
    var state: TaxState = .CA

    /// State Wages as listed on W-2, Box 16
    var wages: IncomeAmountInput = .fullFederal
    var partialIncome: String = ""

    /// State Income Tax Withheld as listed on W-2, Box 17
    var withholdings: String = ""

    /// State Income that's not part of the wages on the W-2
    var additionalStateIncome: String = ""

    /// Any local taxes that apply to this state
    var localTax: LocalTaxTypeInput = .none
}

extension StateIncomeInput: Identifiable {
    var id: UUID { UUID() }
}

struct StateIncomeEntryView: View {
    @Binding var income: StateIncomeInput

    var body: some View {
        Section(header: Text("State Income").fontWeight(.bold)) {
            Picker("State", selection: $income.state) {
                Text("CA").tag(TaxState.CA)
                Text("NY").tag(TaxState.NY)
            }
            Picker("Wages", selection: $income.wages) {
                Text("Full Federal Amount").tag(IncomeAmountInput.fullFederal)
                Text("Partial Amount").tag(IncomeAmountInput.partial)
            }.pickerStyle(.inline)

            if income.wages == .partial {
                TextField("Partial Income", text: $income.partialIncome)
            }

            TextField("State Withholdings", text: $income.withholdings)
            TextField("Additional State Income", text: $income.additionalStateIncome)

            Picker("Local Tax", selection: $income.localTax) {
                Text("None").tag(LocalTaxTypeInput.none)
                Text("NYC").tag(LocalTaxTypeInput.nyc)
            }
        }
    }
}

struct StateIncomeEntryView_Previews: PreviewProvider {
    @State static var stateIncomeInput:StateIncomeInput = StateIncomeInput()
    static var previews: some View {
        Form {
            StateIncomeEntryView(income: $stateIncomeInput)
        }
        .frame(height: 400.0)
    }
}
