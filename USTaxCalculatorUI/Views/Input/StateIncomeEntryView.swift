//
//

import SwiftUI

class StateIncomeInput {
    var income: StateIncome = .init()

    func partialIncomeBinding() -> Binding<Double> {
        return Binding {
            switch self.income.wages {
                case .fullFederal: return 0.0
                case let .partial(val): return val
            }
        } set: { val in
            self.income.wages = .partial(val)
        }
    }
}

struct StateTaxDataEntryView: View {
    @Binding var incomeInput: StateIncomeInput
    let onRemove: () -> ()

    var body: some View {
        Section(header: Text("State Income").fontWeight(.bold)) {
            Picker("State", selection: $incomeInput.income.state) {
                Text("CA").tag(TaxState.CA)
                Text("NY").tag(TaxState.NY)
            }
            Picker("Wages", selection: $incomeInput.income.wages) {
                Text("Full Federal Amount").tag(IncomeAmount.fullFederal)
                Text("Partial Amount").tag(IncomeAmount.partial(0.0))
            }.pickerStyle(.inline)

            if case .partial = incomeInput.income.wages {
                CurrencyValueInputView(caption: "Partial Income",
                                       subtitle: " (W-2, Box 16)",
                                       amount: incomeInput.partialIncomeBinding())
            }

            CurrencyValueInputView(caption: "State Withholdings",
                                   subtitle: " (W-2, Box 17)",
                                   amount: $incomeInput.income.withholdings)
            CurrencyValueInputView(caption: "Additional State Income",
                                   amount: $incomeInput.income.additionalStateIncome)

            Picker("Local Tax", selection: $incomeInput.income.localTax) {
                Text("None").tag(LocalTaxType.none)
                Text("NYC").tag(LocalTaxType.city(.NYC))
            }

            Button("Remove State") {
                onRemove()
            }
        }
    }
}

struct StateTaxDataEntryView_Previews: PreviewProvider {
    @State static var stateIncomeInput: StateIncomeInput = .init()
    static var previews: some View {
        Form {
            StateTaxDataEntryView(incomeInput: $stateIncomeInput,
                                 onRemove: {})
        }
        .padding()
    }
}
