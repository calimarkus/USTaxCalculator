//
// TaxPrimitives.swift
//

public enum TaxYear: Int, Codable, Equatable {
    case y2020 = 2020
    case y2021 = 2021
    case y2022 = 2022
    case y2023 = 2023
}

public enum TaxState: Comparable, Hashable, Codable {
    case NY
    case CA
}

public enum TaxCity: Comparable, Hashable, Codable {
    case NYC
}

public enum LocalTaxType: Hashable, Codable {
    case none
    case city(_ city: TaxCity)
}

public enum FilingType: String, CaseIterable, Codable, Equatable {
    case single = "Single"
    case marriedJointly = "Jointly"
}
