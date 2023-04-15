//
//

// new york rates
extension RawStateTaxRates {
    // NY
    // see https://www.nerdwallet.com/article/taxes/new-york-state-tax
    // see https://www.forbes.com/advisor/taxes/new-york-state-tax/
    // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51
    // Rates apply for incomes < $107,650
    static var progressiveNewYorkStateRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2022: [
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
            .y2021: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.04,
                    8500.0: 0.045,
                    11700.0: 0.0525,
                    13900.0: 0.059,
                    21400.0: 0.0597,
                    80650.0: 0.0633,
                    215400.0: 0.0685,
                    1077550.0: 0.0965,
                    5000000.0: 0.103,
                    25000000.0: 0.109
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.04,
                    17150.0: 0.045,
                    23600.0: 0.0525,
                    27900.0: 0.059,
                    43000.0: 0.0597,
                    161550.0: 0.0633,
                    323200.0: 0.0685,
                    2155350.0: 0.0965,
                    5000000.0: 0.103,
                    25000000.0: 0.109
                ])
            ],
            .y2020: [
                .single: RawTaxRates(progressive: [
                    0.0: 0.04,
                    8500.0: 0.045,
                    11700.0: 0.0525,
                    13900.0: 0.059,
                    21400.0: 0.0609,
                    80650.0: 0.0641,
                    215400.0: 0.0685,
                    1077550.0: 0.0882
                ]),
                .marriedJointly: RawTaxRates(progressive: [
                    0.0: 0.04,
                    17150.0: 0.045,
                    23600.0: 0.0525,
                    27900.0: 0.059,
                    43000.0: 0.0609,
                    161550.0: 0.0641,
                    323200.0: 0.0685,
                    2155350.0: 0.0882
                ])
            ]
        ]
    }

    // see https://www.tax.ny.gov/forms/income_cur_forms.htm
    // see https://www.tax.ny.gov/forms/income_fullyear_forms.htm
    // see https://www.tax.ny.gov/forms/current-forms/it/it201i.htm (IT-201-I instructions)
    //
    // This is simplified - more math is involved to do these properly as above link shows.
    // That rate changes for every increment of 50k, partly based on the progressive rate, which is rather complex.
    // The proper fix is to implement the full tax computation worksheets.
    //
    // Rates apply for incomes >= $107,650
    static var nonProgressiveNewYorkStateRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            // 2022 rates are a fairly rough approximation, mostly based on 2021
            .y2022: [
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
            .y2021: [
                .single: RawTaxRates(simple: [
                    0.0: 0.0633,
                    215400: 0.0685,
                    1077550: 0.0965,
                    5000000: 0.103,
                    25000000.0: 0.109
                ]),
                .marriedJointly: RawTaxRates(simple: [
                    0.0: 0.0597,
                    161550.0: 0.0633,
                    323200.0: 0.0685,
                    2155350.0: 0.0965,
                    5000000.0: 0.103,
                    25000000.0: 0.109
                ])
            ],
            .y2020: [
                // These year 2020 rates are approximated (based on 2021 nonprogressive and progressive 2020)
                .single: RawTaxRates(simple: [
                    0.0: 0.0609,
                    80650.0: 0.0641,
                    215400.0: 0.0685,
                    1077550.0: 0.0882
                ]),
                .marriedJointly: RawTaxRates(simple: [
                    0.0: 0.0609,
                    161550.0: 0.0641,
                    323200.0: 0.0685,
                    2155350.0: 0.0882
                ])
            ]
        ]
    }
}

// new york city rates
extension RawCityTaxRates {
    // NYC
    static var newYorkCityRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
//            .y2023: newYorkCityRatesFrom2017to2023,
            .y2022: newYorkCityRatesFrom2017to2023,
            .y2021: newYorkCityRatesFrom2017to2023,
            .y2020: newYorkCityRatesFrom2017to2023
        ]
    }

    // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
    // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
    // PS: These are full-year resident rates! Part year resident rates might differ
    // Rates apply for incomes > $65,000
    fileprivate static var newYorkCityRatesFrom2017to2023: [FilingType: RawTaxRates] {
        return [
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
    }
}
