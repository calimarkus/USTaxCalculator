//
//

import Foundation

enum TaxYear2022 {
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
                    10276.0: 0.12,
                    41776.0: 0.22,
                    89076.0: 0.24,
                    170051.0: 0.32,
                    215951.0: 0.35,
                    539901.0: 0.37
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.1,
                    20551.0: 0.12,
                    83551.0: 0.22,
                    178151.0: 0.24,
                    340101.0: 0.32,
                    431901.0: 0.35,
                    647851.0: 0.37
                ])
            ],
            // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
            standardDeductions: [
                .single: 12950.0,
                .marriedJointly: 25900.0
            ],
            // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
            // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
            longtermGainsRates: [
                .single: RawTaxRates(simple: [459751.0: 0.20, 41676.0: 0.15]),
                .marriedJointly: RawTaxRates(simple: [517200.0: 0.20, 83351.0: 0.15])
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
            incomeRates: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.01,
                    10100.0: 0.02,
                    23943.0: 0.04,
                    37789.0: 0.06,
                    52456.0: 0.08,
                    66296.0: 0.093,
                    338640.0: 0.103,
                    406365.0: 0.113,
                    677276.0: 0.123
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.01,
                    20199.0: 0.02,
                    47885.0: 0.04,
                    75577.0: 0.06,
                    104911.0: 0.08,
                    132591.0: 0.093,
                    677279.0: 0.103,
                    812729.0: 0.113,
                    1354551.0: 0.123
                ])
            ],
            // see https://www.ftb.ca.gov/file/personal/deductions/index.html
            standardDeductions: [
                .single: 5202.0,
                .marriedJointly: 10404.0
            ])
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        return NewYorkStateTaxRates(
            // see https://www.nerdwallet.com/article/taxes/new-york-state-tax
            // see https://www.forbes.com/advisor/taxes/new-york-state-tax/
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51
            // Rates apply for incomes < $107,650
            incomeRates: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.04,
                    8500.0: 0.045,
                    11700.0: 0.0525,
                    13900.0: 0.0585,
                    80650.0: 0.0625,
                    215400.0: 0.0685,
                    1077550.0: 0.0965,
                    5000000.0: 0.103,
                    25000000.0: 0.109
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.04,
                    17150.0: 0.045,
                    23600.0: 0.0525,
                    27900.0: 0.0585,
                    161550.0: 0.0625,
                    323200.0: 0.0685,
                    2155350.0: 0.0965,
                    5000000.0: 0.103,
                    25000000.0: 0.109
                ])
            ],
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: [
                .single: 8000.0,
                .marriedJointly: 16050.0
            ],
            // These rates are a fairly rough approximation, mostly based on 2021
            nonProgressiveIncomeRates: [
                .single: RawTaxRates(simple: [
                    0.0: 0.0625,
                    215400: 0.0685,
                    1077550: 0.0965,
                    5000000: 0.103,
                    25000000.0: 0.109
                ]),
                .marriedJointly: RawTaxRates(simple: [
                    0.0: 0.0585,
                    161550.0: 0.0633,
                    323200.0: 0.0685,
                    2155350.0: 0.0965,
                    5000000.0: 0.103,
                    25000000.0: 0.109
                ])
            ],
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
