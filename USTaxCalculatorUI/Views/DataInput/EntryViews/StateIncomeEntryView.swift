//
//

import SwiftUI

struct StateTaxDataEntryView: View {
    @Binding var income: StateIncome
    let onRemove: () -> ()

    var body: some View {
        Section(header: Text("State Income").fontWeight(.bold)) {
            Picker("State", selection: $income.state) {
                Text("CA").tag(TaxState.CA)
                Text("NY").tag(TaxState.NY)
            }
            Picker("State Wages", selection: partialIncomePickerBinding()) {
                Text("Full Federal Amount").tag(IncomeAmount.fullFederal)
                Text("Partial Amount").tag(IncomeAmount.partial(0.0))
            }.pickerStyle(.inline)

            if case .partial = income.wages {
                CurrencyValueInputView(caption: "Partial Income",
                                       subtitle: " (W-2, Box 16)",
                                       amount: partialIncomeValueBinding())
            }

            CurrencyValueInputView(caption: "State Withholdings",
                                   subtitle: " (W-2, Box 17)",
                                   amount: $income.withholdings)
            CurrencyValueInputView(caption: "Additional State Income",
                                   amount: $income.additionalStateIncome)

            Picker("Local Tax", selection: $income.localTax) {
                Text("None").tag(LocalTaxType.none)
                Text("NYC").tag(LocalTaxType.city(.NYC))
            }

            Button("Remove State") {
                onRemove()
            }
        }
    }

    func partialIncomePickerBinding() -> Binding<IncomeAmount> {
        return Binding {
            switch self.income.wages {
                case .fullFederal: return .fullFederal
                case .partial: return .partial(0.0)
            }
        } set: { val in
            self.income.wages = val
        }
    }

    func partialIncomeValueBinding() -> Binding<Double> {
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

struct StateTaxDataEntryView_Previews: PreviewProvider {
    @State static var stateIncome: StateIncome = .init()
    static var previews: some View {
        Form {
            StateTaxDataEntryView(income: $stateIncome,
                                 onRemove: {})
        }
        .padding()
    }
}
