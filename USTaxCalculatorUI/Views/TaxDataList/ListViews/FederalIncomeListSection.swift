//
//

import SwiftUI

struct FederalIncomeListSection: View {
    @Binding var isExpanded: Bool

    let taxdata: FederalTaxData
    let income: Income

    var body: some View {
        CollapsableSectionTitle(title: "Income",
                                isFirst: true,
                                isExpanded: $isExpanded)

        TaxListGroupView {
            if isExpanded {
                CurrencyView(CurrencyViewConfig(
                    title: "Wages",
                    amount: income.wages,
                    showSeparator: false
                ))

                if income.capitalGains > 0.0 {
                    CurrencyView(CurrencyViewConfig(
                        title: "Capital gains",
                        amount: income.totalCapitalGains,
                        showPlusMinus: true
                    ))
                    SumView(title: "Total Income", amount: income.totalIncome)
                }

                if income.longtermCapitalGains > 0 {
                    AdditionView(title: "Longterm capital gains",
                                 amount: -income.longtermCapitalGains)
                }

                AdditionView(title: "Deductions", amount: -taxdata.deductions)
            }
            SumView(title: "Taxable Income", amount: taxdata.taxableIncome, showSeparator: isExpanded)
        }
    }
}

struct FederalIncomeListSection_Previews: PreviewProvider {
    @State static var isExpanded1: Bool = true
    @State static var isExpanded2: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            FederalIncomeListSection(
                isExpanded: $isExpanded1,
                taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federal,
                income: ExampleData.exampleTaxDataJohnAndSarah_21().income
            )
            FederalIncomeListSection(
                isExpanded: $isExpanded2,
                taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federal,
                income: ExampleData.exampleTaxDataJohnAndSarah_21().income
            )
        }.padding()
    }
}
