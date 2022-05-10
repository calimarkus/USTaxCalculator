//
//

import Foundation

class TaxDataSet: ObservableObject {
    @Published var selection: Set<Int> = [0] {
        didSet {
            if !selection.isEmpty {
                showEntryForm = false
                editingIndex = nil
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

    @Published var editingIndex: Int?

    func addNewEntry() {
        editingIndex = nil
        showEntryForm = true
    }

    func editEntry(index: Int) {
        editingIndex = index
        showEntryForm = true
    }

    var taxDataInputForEditing: TaxDataInput {
        if let index = editingIndex {
            return taxData[index].input
        } else {
            return .emptyInput()
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
