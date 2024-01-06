//
// LocalTaxDataState.swift
//

import SwiftUI
import TaxIncomeModels
import TaxOutputModels
import TaxCalculator

class LocalTaxDataState: ObservableObject {
    @Published var taxdatas: [CalculatedTaxData] = exampleData()

    func addEntry() -> CalculatedTaxData {
        let data = TaxCalculator.calculateTaxesForInput(.emptyInput())
        taxdatas.append(data)
        return data
    }

    func replaceTaxData(id: UUID, input: TaxDataInput) -> CalculatedTaxData? {
        let idx = taxdatas.firstIndex { td in
            td.id == id
        }
        if let foundIdx = idx {
            taxdatas[foundIdx] = TaxCalculator.calculateTaxesForInput(input)
            return taxdatas[foundIdx]
        }
        return nil
    }

    static func exampleData() -> [CalculatedTaxData] {
        [ExampleData.exampleTaxDataJackHouston_20(),
         ExampleData.exampleTaxDataSimple_20(),
         ExampleData.exampleTaxDataJackHouston_21(),
         ExampleData.exampleTaxDataJohnAndSarah_21()]
    }
}
