//
// NamedValue.swift
//

public struct NamedValue {
    public let amount: Double
    public let name: String

    public init(_ amount: Double, named name: String) {
        self.amount = amount
        self.name = name
    }
}
