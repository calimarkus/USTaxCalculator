//
//

import SwiftUI

struct StateIncomeEntryView: View {
    @Binding var stateIncome: StateIncome

    var body: some View {
        Section(header: Text("Income").fontWeight(.bold)) {
            Picker(selection: IncomeAmount.pickerSelectionBinding($stateIncome.wages)) {
                HStack {
                    Text("Full Federal Amount")
                    #if os(macOS)
                        Text("(matching W-2, Box 1)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    #endif
                }.tag(IncomeAmount.fullFederal)

                Text("Partial Amount:")
                    .tag(IncomeAmount.partial(0.0))
            } label: {
                VStack(alignment: labelAlignment()) {
                    Text("Wages")
                    Text("(W-2, Box 16)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.macOnlyInlinePickerStyle()

            if case .partial = stateIncome.wages {
                CurrencyValueInputView(amount: IncomeAmount.partialValueBinding($stateIncome.wages))
            }

            CurrencyValueInputView(caption: "Additional State Income",
                                   amount: $stateIncome.additionalStateIncome)
        }
    }

    func labelAlignment() -> HorizontalAlignment {
        #if os(macOS)
            .trailing
        #elseif os(iOS)
            .leading
        #endif
    }
}

struct StateIncomeEntryView_Previews: PreviewProvider {
    @State static var stateIncome: StateIncome = .init()

    static var previews: some View {
        Form {
            StateIncomeEntryView(stateIncome: $stateIncome)
        }.macOnlyPadding(30.0)
    }
}
