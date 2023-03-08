//
//

// Federal rates
enum RawFederalTaxRates {
    // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
    static var progressiveMaps: [TaxYear: [FilingType: RawTaxRates]] {
        return [
            .y2021: [
                .single: RawTaxRates([
                    0.0: 0.10,
                    9950.0: 0.12,
                    40525.0: 0.22,
                    86375.0: 0.24,
                    164925.0: 0.32,
                    209425.0: 0.35,
                    523600.0: 0.37
                ]),
                .marriedJointly: RawTaxRates([
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
                .single: RawTaxRates([
                    0.0: 0.10,
                    9875.0: 0.12,
                    40125.0: 0.22,
                    85525.0: 0.24,
                    163300.0: 0.32,
                    207350.0: 0.35,
                    518400.0: 0.37
                ]),
                .marriedJointly: RawTaxRates([
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
}
