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
                CurrencyView(title: "Wages", amount: income.wages)
                CurrencyView(title: "Capital gains",
                             amount: income.totalCapitalGains,
                             showPlusMinus: true)
                SumView(title: "Total Income", amount: income.totalIncome)
                if income.longtermCapitalGains > 0 {
                    AdditionView(title: "Longterm gains",
                                 amount: -income.longtermCapitalGains)
                }
                AdditionView(title: "Deductions", amount: -taxdata.deductions)
            }
            SumView(title: "Taxable Income", amount: taxdata.taxableIncome)
        }
    }
}

struct FederalIncomeListSection_Previews: PreviewProvider {
    @State static var isExpanded: Bool = true
    static var previews: some View {
        FederalIncomeListSection(
            isExpanded: $isExpanded,
            taxdata: ExampleData.exampleTaxDataJohnAndSarah_21().federal,
            income: ExampleData.exampleTaxDataJohnAndSarah_21().income
        ).padding()
    }
}
