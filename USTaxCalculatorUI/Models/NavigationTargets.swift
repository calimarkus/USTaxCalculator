//
// NavigationTargets.swift
//

import TaxCalculator

struct NavigationTarget: Hashable {
    let taxdata: CalculatedTaxData
    var isEditing: Bool = false
}
