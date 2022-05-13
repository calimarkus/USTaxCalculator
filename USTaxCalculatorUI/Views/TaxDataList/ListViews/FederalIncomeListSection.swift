//
//

import SwiftUI

struct FederalIncomeListSection: View {
    @ObservedObject var collapseState: SectionCollapseState

    let taxdata: CalculatedTaxData
    var income: Income { return taxdata.income }

    var body: some View {
        CollapsableSection(title: "Income",
                           isFirst: true,
                           expandedBinding: $collapseState.income) { expanded in
            TaxListGroupView {
                if expanded {
                    CurrencyView(title: "Wages", amount: income.wages)
                    CurrencyView(title: "Capital gains",
                                 amount: income.totalCapitalGains,
                                 showPlusMinus: true)
                    SumView(title: "Total Income", amount: income.totalIncome)
                    if income.longtermCapitalGains > 0 {
                        AdditionView(title: "Longterm gains",
                                     amount: -income.longtermCapitalGains)
                    }
                    AdditionView(title: "Deductions", amount: -taxdata.federalDeductions)
                }
                SumView(title: "Taxable Income", amount: taxdata.taxableFederalIncome)
            }
        }
    }
}

struct FederalIncomeListSection_Previews: PreviewProvider {
    static var previews: some View {
        FederalIncomeListSection(
            collapseState: SectionCollapseState(),
            taxdata: ExampleData.exampleTaxDataJohnAndSarah_21()
        ).padding()
    }
}
