//
//

struct StandardDeductions {
    static func state(taxYear:TaxYear, state:StateOrCity, filingType:FilingType) -> Double {
        switch taxYear {
            case .y2021: switch state {
                case .NY, .NYC:
                    // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
                    switch filingType {
                        case .single: return 8000.0
                        case .marriedJointly: return 16050.0
                    }
                case .CA:
                    // see https://www.ftb.ca.gov/file/personal/deductions/index.html
                    switch filingType {
                        case .single: return 4803.0
                        case .marriedJointly: return 9606.0
                    }
            }
            case .y2020: switch state {
                case .NY, .NYC:
                    // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
                    switch filingType {
                        case .single: return 8000.0
                        case .marriedJointly: return 16050.0
                    }
                case .CA:
                    // see https://www.ftb.ca.gov/about-ftb/newsroom/tax-news/november-2020/standard-deductions-exemption-amounts-and-tax-rates-for-2020-tax-year.html
                    switch filingType {
                        case .single: return 4601.0
                        case .marriedJointly: return 9202.0
                    }
            }
        }
    }

    // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
    static func federal(taxYear:TaxYear, filingType:FilingType) -> Double {
        switch taxYear {
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
}
