//
//

import SwiftUI

extension GlobalAppState {
    func selectionBinding() -> Binding<Set<Int>> {
        return Binding {
            switch self.navigationState {
                case .empty, .addNewEntry:
                    return []
                case .entry(let entryIndex, _):
                    return [entryIndex]
            }
        } set: { val in
            if let idx = val.first {
                if self.taxdata.count > idx {
                    self.navigationState = .entry(entryIndex: idx, isEditing: false)
                }
            } else {
                self.navigationState = .empty
            }
        }
    }
}
