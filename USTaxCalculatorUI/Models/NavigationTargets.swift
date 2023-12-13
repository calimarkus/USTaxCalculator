//
// NavigationTargets.swift
//

import TaxOutputModels

struct NavigationTarget: Hashable {
    let taxdata: CalculatedTaxData
    var isEditing: Bool = false
}
