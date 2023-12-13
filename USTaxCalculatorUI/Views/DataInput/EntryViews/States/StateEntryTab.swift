//
// StateEntryTab.swift
//

import SwiftUI
import TaxInputModels

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

                if notFirstSection { MacOnlySpacer(height: 20) }
                BasicStateInfoEntryView(stateIncome: stateIncome, headerContent: {
                    StateTitleButton(stateIncome: stateIncome, showRemoveButton: notFirstSection) {
                        withAnimation {
                            removeIncomeAtIndex(i)
                        }
                    }
                })
                MacOnlySpacer(height: 20)
                StateIncomeEntryView(stateIncome: stateIncome)
                MacOnlySpacer(height: 20)
                StateTaxReductionsEntryView(input: $input, stateIncome: stateIncome)
            }

            AddStateButton {
                withAnimation {
                    input.income.stateIncomes.append(StateIncome())
                }
            }
        }
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
