//
//

enum TaxYear: Int, Codable, Equatable {
    case y2020 = 2020
    case y2021 = 2021
    case y2022 = 2022
//    case y2023 = 2023
}

enum DeductionAmount: Hashable, Codable, Equatable {
    case standard(additionalDeductions: Double = 0.0)
    case custom(_ amount: Double)
}

enum FilingType: String, CaseIterable, Codable, Equatable {
    case single = "Single"
    case marriedJointly = "Jointly"
}

struct TaxDataInput: Codable, Equatable {
    /// An additional description for this data, which will be combined with the default title if provided like e.g. "title - Year 2021 (Single, NY+CA)"
    var title: String = ""
    /// true if the taxes are filed jointly as a married couple, otherwise single is assumed
    var filingType: FilingType = .single
    /// the tax year for these taxes
    var taxYear: TaxYear = .y2021
    /// The Income to use in the calculations
    var income: Income = .init()

    /// Federal deductions that apply.
    var federalDeductions: DeductionAmount = .standard()
    /// State deductions that apply to each state. Missing states will utilize standard deductions.
    var stateDeductions: [TaxState: DeductionAmount] = [:]

    /// Federal withholdings not listed on the W-2 (e.g. estimated payments, etc.)
    var additionalFederalWithholding: Double = 0.0

    /// Tax credits that apply to your federal taxes
    var federalCredits: Double = 0.0
    /// Tax credits that apply to your state taxes
    var stateCredits: [TaxState: Double] = [:]

    static func emptyInput() -> TaxDataInput {
        return .init(income: Income(stateIncomes: [StateIncome()]))
    }
}
