//
//

import Foundation

class TaxDataSet: ObservableObject {
    @Published var selection: Set<Int> = [0] {
        didSet {
            if !selection.isEmpty {
                showEntryForm = false
            }
        }
    }

    @Published var showEntryForm: Bool = false {
        didSet {
            if showEntryForm {
                selection = []
            }
        }
    }

    var activeTaxData: USTaxData? {
        if !showEntryForm, let idx = selection.first {
            return taxData[idx]
        }

        return nil
    }

    @Published var taxData: [USTaxData] = [ExampleData.exampleTaxDataJohnAndSarah_21(),
                                           ExampleData.exampleTaxDataJackHouston_21(),
                                           ExampleData.exampleTaxDataJackHouston_20()]
}
