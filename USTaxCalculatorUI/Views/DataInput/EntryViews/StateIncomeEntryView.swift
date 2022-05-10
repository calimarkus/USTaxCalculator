//
//

import SwiftUI

struct StateTaxDataEntryView: View {
    @Binding var income: StateIncome
    let idx: Int
    let onRemove: () -> ()

    var body: some View {
        Section {
            HStack {
                let buttonTitle = "State Income \(idx + 1) (\(income.state))"
                let buttonText = Text(buttonTitle).fontWeight(.bold)
                if idx > 0 {
                    Button {
                        onRemove()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                        buttonText
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 10.0)
                } else {
                    buttonText
                }
            }
            Picker("State", selection: $income.state) {
                Text("CA").tag(TaxState.CA)
                Text("NY").tag(TaxState.NY)
            }
            Picker(selection: partialIncomePickerBinding()) {
                HStack {
                    Text("Full Federal Amount")
                    Text("(matching W-2, Box 1)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }.tag(IncomeAmount.fullFederal)
                Text("Partial Amount:").tag(IncomeAmount.partial(0.0))
            } label: {
                VStack(alignment: .trailing) {
                    Text("State Wages")
                    Text("(W-2, Box 16)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.pickerStyle(.inline)

            if case .partial = income.wages {
                CurrencyValueInputView(caption: "",
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
                                  idx: 0,
                                  onRemove: {})
            StateTaxDataEntryView(income: $stateIncome,
                                  idx: 1,
                                  onRemove: {})
        }
        .padding()
    }
}
