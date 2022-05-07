//
//

import SwiftUI

struct FederalIncomeListSection: View {
    let taxdata:USTaxData
    var income:Income { get { return taxdata.income }}

    var body: some View {
        CollapsableSection(
            title: "Income",
            collapsableContent: {
                CurrencyView(title: "Wages", amount: income.wages)
                AdditionView(title: "Capital gains", amount: income.totalCapitalGains)
                SumView(title: "Total Income", amount: income.totalIncome)
                if income.longtermCapitalGains > 0 {
                    AdditionView(title: "Longterm gains", amount: -income.longtermCapitalGains)
                }
                AdditionView(title: "Deductions", amount: -taxdata.federalDeductions)
            }, fixedContent: {
                SumView(title: "Taxable Income", amount: taxdata.taxableFederalIncome)
            }
        )
    }
}

struct FederalIncomeListSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FederalIncomeListSection(taxdata: ExampleData.single21Data())
        }
    }
}
