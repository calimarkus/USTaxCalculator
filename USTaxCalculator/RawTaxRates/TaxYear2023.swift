//
//

import Foundation

enum TaxYear2023 {
    static var taxRates: RawTaxRatesYear {
        return RawTaxRatesYear(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates)
    }

    private static var federalRates: FederalTaxRates {
        return FederalTaxRates(
            // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
            incomeRates: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.10,
                    11001.0: 0.12,
                    44726.0: 0.22,
                    95376.0: 0.24,
                    182101.0: 0.32,
                    231251.0: 0.35,
                    578126.0: 0.37
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.1,
                    22001.0: 0.12,
                    89451.0: 0.22,
                    190751.0: 0.24,
                    364201.0: 0.32,
                    462501.0: 0.35,
                    693751.0: 0.37
                ])
            ],
            standardDeductions: [
                .single: 0.0, // TBD
                .marriedJointly: 0.0 // TBD
            ],
            longtermGainsRates: [
                .single: RawTaxRates(simple: [:]), // TBD
                .marriedJointly: RawTaxRates(simple: [:]) // TBD
            ],
            // see https://www.irs.gov/individuals/net-investment-income-tax
            netInvestmentIncomeRates: [
                .single: RawTaxRates(simple: [200000.0: 0.038]),
                .marriedJointly: RawTaxRates(simple: [250000.0: 0.038])
            ],
            // see https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers
            basicMedicareIncomeRates: [
                .single: RawTaxRates(simple: [0.0: 0.0145]),
                .marriedJointly: RawTaxRates(simple: [0.0: 0.0145])
            ],
            // see https://www.healthline.com/health/medicare/additional-medicare-tax
            additionalMedicareIncomeRates: [
                .single: RawTaxRates(progressive: [0.0: 0.0, 200000.0: 0.009]),
                .marriedJointly: RawTaxRates(simple: [0.0: 0.0, 250000.0: 0.009])
            ])
    }

    // CA
    // see https://www.nerdwallet.com/article/taxes/california-state-tax
    // see https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf
    //
    // Note: These are only valid for incomes of $100,000+
    private static var californiaRates: CaliforniaStateTaxRates {
        return CaliforniaStateTaxRates(
            incomeRates: [:], // TBD
            // see https://www.ftb.ca.gov/file/personal/deductions/index.html
            standardDeductions: [:] // TBD
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        return NewYorkStateTaxRates(
            incomeRates: [:], // TBD
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: [
                .single: 8000.0,
                .marriedJointly: 16050.0
            ],
            nonProgressiveIncomeRates: [:], // TBD
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
            // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
            // PS: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.03078,
                    12000.0: 0.03762,
                    25000.0: 0.03819,
                    50000.0: 0.03876
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.03078,
                    21600.0: 0.03762,
                    45000.0: 0.03819,
                    90000.0: 0.03876
                ])
            ]
        )
    }
}
