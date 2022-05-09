//
//

import Foundation

class TaxDataSet: ObservableObject {
    @Published var selection: Set<Int> = [0]

    var activeTaxData: USTaxData? {
        if let idx = selection.first {
            return taxData[idx]
        } else {
            return nil
        }
    }

    let taxData: [USTaxData] = [ExampleData.exampleTaxDataJohnAndSarah_21(),
                                ExampleData.exampleTaxDataJackHouston_21(),
                                ExampleData.exampleTaxDataJackHouston_20()]
}
