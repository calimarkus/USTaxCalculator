//
//

import SwiftUI

class LocalTaxDataState: ObservableObject {
    @Published var taxdatas: [CalculatedTaxData] = []
    @Published var editingInput: TaxDataInput? = nil

    init() {
        taxdatas = exampleData()
    }

    func addEntry() {
        taxdatas.append(try! CalculatedTaxData(.emptyInput()))
    }

    func updateTaxDataWithEditingInput(taxdata: CalculatedTaxData) {
        if let input = editingInput {
            let idx = taxdatas.firstIndex { td in
                td.id == taxdata.id
            }
            if let foundIdx = idx {
                taxdatas[foundIdx] = try! CalculatedTaxData(input)
            }
        }
    }

    func exampleData() -> [CalculatedTaxData] {
        [ExampleData.exampleTaxDataJackHouston_20(),
         ExampleData.exampleTaxDataSimple_20(),
         ExampleData.exampleTaxDataJackHouston_21(),
         ExampleData.exampleTaxDataJohnAndSarah_21()]
    }

    func editingInputBinding() -> Binding<TaxDataInput>? {
        if let _ = editingInput {
            return Binding {
                self.editingInput!
            } set: { val in
                self.editingInput = val
            }
        } else {
            return nil
        }
    }
}
