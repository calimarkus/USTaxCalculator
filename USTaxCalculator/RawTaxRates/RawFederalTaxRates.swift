//
//

// Federal rates
enum RawFederalTaxRates {
    // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
    static var progressiveIncomeRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            //            .y2023: [
//                .single: RawTaxRates([
//                    0.0: 0.10,
//                    11001.0: 0.12,
//                    44726.0: 0.22,
//                    95376.0: 0.24,
//                    182101.0: 0.32,
//                    231251.0: 0.35,
//                    578126.0: 0.37
//                ]),
//                .marriedJointly: RawTaxRates([
//                    0.0: 0.1,
//                    22001.0: 0.12,
//                    89451.0: 0.22,
//                    190751.0: 0.24,
//                    364201.0: 0.32,
//                    462501.0: 0.35,
//                    693751.0: 0.37
//                ])
//            ],
            .y2022: [
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
            .y2021: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.10,
                    9950.0: 0.12,
                    40525.0: 0.22,
                    86375.0: 0.24,
                    164925.0: 0.32,
                    209425.0: 0.35,
                    523600.0: 0.37
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.1,
                    19900.0: 0.12,
                    81050.0: 0.22,
                    172750.0: 0.24,
                    329850.0: 0.32,
                    418850.0: 0.35,
                    628300.0: 0.37
                ])
            ],
            .y2020: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.10,
                    9875.0: 0.12,
                    40125.0: 0.22,
                    85525.0: 0.24,
                    163300.0: 0.32,
                    207350.0: 0.35,
                    518400.0: 0.37
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.1,
                    19750.0: 0.12,
                    80250.0: 0.22,
                    171050.0: 0.24,
                    326600.0: 0.32,
                    414700.0: 0.35,
                    622050.0: 0.37
                ])
            ]
        ]
    }

    // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
    // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
    static var longtermGainsRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2022: [
                .single: RawTaxRates(simple: [459751.0: 0.20, 41676.0: 0.15]),
                .marriedJointly: RawTaxRates(simple: [517200.0: 0.20, 83351.0: 0.15])
            ],
            .y2021: [
                .single: RawTaxRates(simple: [445850.0: 0.20, 40400.0: 0.15]),
                .marriedJointly: RawTaxRates(simple: [501600.0: 0.20, 80800.0: 0.15])
            ],
            .y2020: [
                .single: RawTaxRates(simple: [441450.0: 0.20, 40000.0: 0.15]),
                .marriedJointly: RawTaxRates(simple: [496600.0: 0.20, 80000.0: 0.15])
            ]
        ]
    }

    // see https://www.irs.gov/individuals/net-investment-income-tax
    //
    // - "Net investment income" generally does not include wages, social security benefits, ...
    // - The tax applies to the the lesser of the net investment income, or the amount by which the
    //   modified adjusted gross income exceeds the statutory threshold amount
    static var netInvestmentIncomeRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2022: netInvestmentIncomeRatesFrom2013to2023,
            .y2021: netInvestmentIncomeRatesFrom2013to2023,
            .y2020: netInvestmentIncomeRatesFrom2013to2023
        ]
    }

    fileprivate static var netInvestmentIncomeRatesFrom2013to2023: [FilingType: RawTaxRates] {
        return [
            .single: RawTaxRates(simple: [200000.0: 0.038]),
            .marriedJointly: RawTaxRates(simple: [250000.0: 0.038])
        ]
    }

    // see https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers
    //
    // usually withheld by the employer
    //
    static var basicMedicareIncomeRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2022: basicMedicareTaxRatesFrom2013to2023,
            .y2021: basicMedicareTaxRatesFrom2013to2023,
            .y2020: basicMedicareTaxRatesFrom2013to2023
        ]
    }

    fileprivate static var basicMedicareTaxRatesFrom2013to2023: [FilingType: RawTaxRates] {
        return [
            .single: RawTaxRates(simple: [0.0: 0.0145]),
            .marriedJointly: RawTaxRates(simple: [0.0: 0.0145])
        ]
    }

    // see https://www.healthline.com/health/medicare/additional-medicare-tax
    //
    // usually withheld by the employer
    //
    static var additionalMedicareIncomeRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2022: additionalMedicareIncomeRatesFrom2013to2023,
            .y2021: additionalMedicareIncomeRatesFrom2013to2023,
            .y2020: additionalMedicareIncomeRatesFrom2013to2023
        ]
    }

    fileprivate static var additionalMedicareIncomeRatesFrom2013to2023: [FilingType: RawTaxRates] {
        return [
            .single: RawTaxRates(progressive: [0.0: 0.0, 200000.0: 0.009]),
            .marriedJointly: RawTaxRates(simple: [0.0: 0.0, 250000.0: 0.009])
        ]
    }
}
