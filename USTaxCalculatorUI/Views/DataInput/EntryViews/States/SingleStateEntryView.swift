//
//

import SwiftUI

struct SingleStateEntryView: View {
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

        BasicStateInfoEntryView(stateIncome: $stateIncome)
        StateIncomeEntryView(stateIncome: $stateIncome)
        StateTaxReductionsEntryView(input: $input, stateIncome: $stateIncome)
    }
}

struct SingleStateEntryView_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .emptyInput()
    @State static var stateIncome: StateIncome = .init()
    static var previews: some View {
        Form {
            SingleStateEntryView(input: $input,
                                 stateIncome: $stateIncome,
                                 idx: 0)
            SingleStateEntryView(input: $input,
                                 stateIncome: $stateIncome,
                                 idx: 1)
        }
        .padding()
        .frame(height: 900)
    }
}
