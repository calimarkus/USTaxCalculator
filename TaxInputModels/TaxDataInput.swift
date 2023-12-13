//
// TaxDataInput.swift
//

import TaxPrimitives

public enum DeductionInput: Hashable, Codable, Equatable {
    case standard(additionalDeductions: Double = 0.0)
    case custom(_ amount: Double)
}

public struct TaxDataInput: Codable, Equatable {
    /// An additional description for this data, which will be combined with the default title if provided like e.g. "title - Year 2021 (Single, NY+CA)"
    public var title: String = ""
    /// true if the taxes are filed jointly as a married couple, otherwise single is assumed
    public var filingType: FilingType = .single
    /// the tax year for these taxes
    public var taxYear: TaxYear = .y2021
    /// The Income to use in the calculations
    public var income: Income = .init()

    /// Federal deductions that apply.
    public var federalDeductions: DeductionInput = .standard()
    /// State deductions that apply to each state. Missing states will utilize standard deductions.
    public var stateDeductions: [TaxState: DeductionInput] = [:]

    /// Federal withholdings not listed on the W-2 (e.g. estimated payments, etc.)
    public var additionalFederalWithholding: Double = 0.0

    /// Tax credits that apply to your federal taxes
    public var federalCredits: Double = 0.0
    /// Tax credits that apply to your state taxes
    public var stateCredits: [TaxState: Double] = [:]

    public init(title: String = "", filingType: FilingType = .single, taxYear: TaxYear = .y2021, income: Income = .init(), federalDeductions: DeductionInput = .standard(), stateDeductions: [TaxState : DeductionInput] = [:], additionalFederalWithholding: Double = 0.0, federalCredits: Double = 0.0, stateCredits: [TaxState : Double] = [:]) {
        self.title = title
        self.filingType = filingType
        self.taxYear = taxYear
        self.income = income
        self.federalDeductions = federalDeductions
        self.stateDeductions = stateDeductions
        self.additionalFederalWithholding = additionalFederalWithholding
        self.federalCredits = federalCredits
        self.stateCredits = stateCredits
    }

    public static func emptyInput() -> TaxDataInput {
        .init(income: Income(stateIncomes: [StateIncome()]))
    }

    public var totalFederalWitholdings: Double {
        income.federalWithholdings + additionalFederalWithholding
    }
}
