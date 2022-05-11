//
//

import SwiftUI

struct StateIncomeEntryView: View {
    @Binding var stateIncome: StateIncome

    var body: some View {
        Spacer().frame(height: 20.0)

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
    }
}

struct StateIncomeEntryView_Previews: PreviewProvider {
    @State static var stateIncome: StateIncome = .init()

    static var previews: some View {
        Form {
            StateIncomeEntryView(stateIncome: $stateIncome)
        }.padding()
    }
}
