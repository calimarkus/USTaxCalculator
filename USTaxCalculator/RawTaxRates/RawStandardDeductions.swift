//
//

enum RawStandardDeductions {
    // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
    static func federal(taxYear: TaxYear, filingType: FilingType) -> Double {
        switch taxYear {
            case .y2022: switch filingType {
                    case .single: return 12950.0
                    case .marriedJointly: return 25900.0
                }
            case .y2021: switch filingType {
                    case .single: return 12550.0
                    case .marriedJointly: return 25100.0
                }
            case .y2020: switch filingType {
                    case .single: return 12400.0
                    case .marriedJointly: return 24800.0
                }
        }
    }

    static func state(taxYear: TaxYear, state: TaxState, filingType: FilingType) -> Double {
        switch state {
            case .NY:
                switch taxYear {
                    case .y2022, .y2021, .y2020:
                        // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
                        // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
                        switch filingType {
                            case .single: return 8000.0
                            case .marriedJointly: return 16050.0
                        }
                }
            case .CA:
                switch taxYear {
                    case .y2022:
                        // see https://www.ftb.ca.gov/file/personal/deductions/index.html
                        switch filingType {
                            case .single: return 5202.0
                            case .marriedJointly: return 10404.0
                        }
                    case .y2021:
                        // see https://www.ftb.ca.gov/file/personal/deductions/index.html
                        switch filingType {
                            case .single: return 4803.0
                            case .marriedJointly: return 9606.0
                        }
                    case .y2020:
                        // see https://www.ftb.ca.gov/about-ftb/newsroom/tax-news/november-2020/standard-deductions-exemption-amounts-and-tax-rates-for-2020-tax-year.html
                        switch filingType {
                            case .single: return 4601.0
                            case .marriedJointly: return 9202.0
                        }
                }
        }
    }
}
