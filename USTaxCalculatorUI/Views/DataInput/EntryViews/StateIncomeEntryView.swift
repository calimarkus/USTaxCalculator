//
//

import SwiftUI

struct StateIncomeEntryView: View {
    @Binding var input: TaxDataInput
    @Binding var stateIncome: StateIncome

    let idx: Int

    var body: some View {
        HStack {
            let buttonTitle = "\(stateIncome.state) Taxes"
            let buttonText = Text(buttonTitle).fontWeight(.bold)
            if idx > 0 {
                Button {
                    input.income.stateIncomes.remove(at: idx)
                } label: {
                    Image(systemName: "minus.circle.fill")
                    buttonText
                }
                .buttonStyle(.plain)
                .padding(.top, 10.0)
            } else {
                buttonText
            }
        }.padding(.top, idx == 0 ? 0 : 20.0)

        Picker("State", selection: $stateIncome.state) {
            Text("CA").tag(TaxState.CA)
            Text("NY").tag(TaxState.NY)
        }.frame(maxWidth: 180)

        Picker("Local Tax", selection: $stateIncome.localTax) {
            Text("None").tag(LocalTaxType.none)
            Text("NYC").tag(LocalTaxType.city(.NYC))
        }.frame(maxWidth: 180)

        Spacer(minLength: 20.0)

        Section(header: Text("Income").fontWeight(.bold)) {
            Picker(selection: IncomeAmount.pickerSelectionBinding($stateIncome.wages)) {
                HStack {
                    Text("Full Federal Amount")
                    Text("(matching W-2, Box 1)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }.tag(IncomeAmount.fullFederal)
                Text("Partial Amount:").tag(IncomeAmount.partial(0.0))
            } label: {
                VStack(alignment: .trailing) {
                    Text("Wages")
                    Text("(W-2, Box 16)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.pickerStyle(.inline)

            CurrencyValueInputView(caption: "Additional State Income",
                                   amount: $stateIncome.additionalStateIncome)

            if case .partial = stateIncome.wages {
                CurrencyValueInputView(caption: "",
                                       amount: IncomeAmount.partialValueBinding($stateIncome.wages))
            }
        }

        Spacer(minLength: 20.0)

        Section(header: Text("Tax Reductions").fontWeight(.bold)) {
            CurrencyValueInputView(caption: "Withholdings",
                                   subtitle: " (W-2, Box 17)",
                                   amount: $stateIncome.withholdings)

            CurrencyValueInputView(caption: "Tax Credits",
                                   amount: TaxDataInput.stateCreditsBinding($input.stateCredits,
                                                                            for: stateIncome.state))

            DeductionsPickerView(deductions: TaxDataInput.stateDeductionsBinding($input.stateDeductions, for: stateIncome.state))
        }
    }
}

struct StateIncomeEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .emptyInput()
    @State static var stateIncome: StateIncome = .init()
    static var previews: some View {
        Form {
            StateIncomeEntryView(input: $input,
                                 stateIncome: $stateIncome,
                                 idx: 0)
            StateIncomeEntryView(input: $input,
                                 stateIncome: $stateIncome,
                                 idx: 1)
        }
        .padding()
        .frame(height: 800)
    }
}
