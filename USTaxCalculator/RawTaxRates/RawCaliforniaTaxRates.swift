//
//

// California rates
extension RawStateTaxRates {
    // CA
    // see https://www.nerdwallet.com/article/taxes/california-state-tax
    // see https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf
    //
    // Note: These are only valid for incomes of $100,000+
    static var californiaRates: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2021: [
                .single: RawTaxRates([
                    0.0: 0.01,
                    9325.0: 0.02,
                    22107.0: 0.04,
                    34892.0: 0.06,
                    48435.0: 0.08,
                    61214.0: 0.093,
                    312686.0: 0.103,
                    375221.0: 0.113,
                    625369.0: 0.123
                ]),
                .marriedJointly: RawTaxRates([
                    0.0: 0.01,
                    18650.0: 0.02,
                    44214.0: 0.04,
                    69784.0: 0.06,
                    96870.0: 0.08,
                    122428.0: 0.093,
                    625372.0: 0.103,
                    750442.0: 0.113,
                    1250738.0: 0.123
                ])
            ],
            .y2020: [
                .single: RawTaxRates([
                    0.0: 0.01,
                    8932.0: 0.02,
                    21175.0: 0.04,
                    33421.0: 0.06,
                    46394.0: 0.08,
                    58634.0: 0.093,
                    299508.0: 0.103,
                    359407.0: 0.113,
                    599012.0: 0.123
                ]),
                .marriedJointly: RawTaxRates([
                    0.0: 0.01,
                    17864.0: 0.02,
                    42350.0: 0.04,
                    66842.0: 0.06,
                    92788.0: 0.08,
                    117268.0: 0.093,
                    599016.0: 0.103,
                    718814.0: 0.113,
                    1198024.0: 0.123
                ])
            ]
        ]
    }
}
