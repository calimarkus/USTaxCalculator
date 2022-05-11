//
//

import Foundation

enum NavigationState {
    case empty
    case addNewEntry
    case entry(entryIndex: Int, isEditing: Bool = false)
}

class GlobalAppState: ObservableObject {
    @Published var taxdata: [CalculatedTaxData]
    @Published var navigationState: NavigationState

    init() {
        let data = [ExampleData.exampleTaxDataJohnAndSarah_21(),
                    ExampleData.exampleTaxDataJackHouston_21(),
                    ExampleData.exampleTaxDataJackHouston_20()]

        taxdata = data
        navigationState = .entry(entryIndex: 0, isEditing: false)
    }

    func saveData(_ newData: CalculatedTaxData) {
        switch navigationState {
            case .empty:
                break
            case .addNewEntry:
                taxdata.append(newData)
                navigationState = .entry(entryIndex: taxdata.count - 1)
            case .entry(let entryIndex, let isEditing):
                if isEditing {
                    taxdata.remove(at: entryIndex)
                    taxdata.insert(newData, at: entryIndex)
                    navigationState = .entry(entryIndex: entryIndex)
                }
        }
    }
}
