//
//

import SwiftUI

struct StateEntryTab: View {
    @Binding var input: TaxDataInput

    var body: some View {
        #if os(macOS)
            ScrollView {
                HStack {
                    Spacer()
                    form()
                        .frame(maxWidth: 500)
                        .padding()
                    Spacer()
                }
            }
        #else
            form()
        #endif
    }

    @ViewBuilder
    func form() -> some View {
        Form {
            ForEach(input.income.stateIncomes.indices, id: \.self) { i in
                let notFirstSection = i > 0
                let stateIncome = $input.income.stateIncomes[i]

                if notFirstSection { macOnlySpacer() }
                BasicStateInfoEntryView(stateIncome: stateIncome, headerContent: {
                    StateTitleButton(stateIncome: stateIncome, showRemoveButton: notFirstSection) {
                        withAnimation {
                            removeIncomeAtIndex(i)
                        }
                    }
                })
                macOnlySpacer()
                StateIncomeEntryView(stateIncome: stateIncome)
                macOnlySpacer()
                StateTaxReductionsEntryView(input: $input, stateIncome: stateIncome)
            }

            AddStateButton {
                withAnimation {
                    input.income.stateIncomes.append(StateIncome())
                }
            }
        }
    }

    @ViewBuilder
    func macOnlySpacer() -> some View {
        #if os(macOS)
            Spacer().frame(height: 20.0)
        #endif
    }

    func removeIncomeAtIndex(_ idx: Int) {
        input.income.stateIncomes.remove(at: idx)
    }
}

struct StateEntryTab_Previews: PreviewProvider {
    @State static var input: TaxDataInput = .init(income: Income(stateIncomes: [StateIncome(), StateIncome()]))

    static var previews: some View {
        StateEntryTab(input: $input)
        #if os(macOS)
            .padding()
            .frame(height: 900.0)
        #endif
    }
}
