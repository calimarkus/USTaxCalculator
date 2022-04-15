//
//

struct RawStartingAtToTaxRateMap {}

// state rates
extension RawStartingAtToTaxRateMap {
    static func progressiveMapsForState(_ state:State) -> [TaxYear: [FilingType: [Double:Double]]] {
        switch state {
            case .NY: return self.progressiveNewYorkStateRates
            case .CA: return self.californiaRates
        }
    }

    static func progressiveMapsForCity(_ city:City) -> [TaxYear: [FilingType: [Double:Double]]] {
        switch city {
            case .NYC: return self.newYorkCityRates
        }
    }
}

// federal rates
extension RawStartingAtToTaxRateMap {
    // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
    static var federalProgressiveMaps: [TaxYear: [FilingType: [Double:Double]]] { get {
        return [
            .y2021: [
                .single: [
                    0.0 : 0.10,
                    9950.0 : 0.12,
                    40525.0 : 0.22,
                    86375.0 : 0.24,
                    164925.0 : 0.32,
                    209425.0 : 0.35,
                    523600.0 : 0.37],
                .marriedJointly: [
                    0.0 : 0.1,
                    19900.0 : 0.12,
                    81050.0 : 0.22,
                    172750.0 : 0.24,
                    329850.0 : 0.32,
                    418850.0 : 0.35,
                    628300.0 : 0.37]],
            .y2020: [
                .single: [
                    0.0 : 0.10,
                    9875.0 : 0.12,
                    40125.0 : 0.22,
                    85525.0 : 0.24,
                    163300.0 : 0.32,
                    207350.0 : 0.35,
                    518400.0 : 0.37],
                .marriedJointly: [
                    0.0 : 0.1,
                    19750.0 : 0.12,
                    80250.0 : 0.22,
                    171050.0 : 0.24,
                    326600.0 : 0.32,
                    414700.0 : 0.35,
                    622050.0 : 0.37]]
        ]
    }}
}

// new york rates
extension RawStartingAtToTaxRateMap {
    // NY
    // see https://www.nerdwallet.com/article/taxes/new-york-state-tax
    // see https://www.forbes.com/advisor/taxes/new-york-state-tax/
    // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51
    // Rates apply for incomes <= $107,650
    private static var progressiveNewYorkStateRates: [TaxYear: [FilingType: [Double:Double]]] { get {
        return [
            .y2021: [
                .single: [
                    0.0 : 0.04,
                    8500.0 : 0.045,
                    11700.0 : 0.0525,
                    13900.0 : 0.059,
                    21400.0 : 0.0597,
                    80650.0 : 0.0633,
                    215400.0 : 0.0685,
                    1077550.0 : 0.0965,
                    5000000.0 : 0.103,
                    25000000.0 : 0.109],
                .marriedJointly: [
                    0.0 : 0.04,
                    17150.0 : 0.045,
                    23600.0 : 0.0525,
                    27900.0 : 0.059,
                    43000.0 : 0.0597,
                    161550.0 : 0.0633,
                    323200.0 : 0.0685,
                    2155350.0 : 0.0965,
                    5000000.0 : 0.103,
                    25000000.0 : 0.109]],
            .y2020: [
                .single: [
                    0.0 : 0.04,
                    8500.0 : 0.045,
                    11700.0 : 0.0525,
                    13900.0 : 0.059,
                    21400.0 : 0.0609,
                    80650.0 : 0.0641,
                    215400.0 : 0.0685,
                    1077550.0 : 0.0882],
                .marriedJointly: [
                    0.0 : 0.04,
                    17150.0 : 0.045,
                    23600.0 : 0.0525,
                    27900.0 : 0.059,
                    43000.0 : 0.0609,
                    161550.0 : 0.0641,
                    323200.0 : 0.0685,
                    2155350.0 : 0.0882]]
        ]
    }}

    // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=52
    // this is slightly simplified - more math is involved to do these properly as above link shows.
    // That math is different for each bracket, which is rather complex.
    // Rates apply for incomes $107,650+
    static var nonProgressiveNewYorkStateRates: [TaxYear: [FilingType: [Double:Double]]] { get {
        return [
            .y2021: [
                .single: [
                    0.0 : 0.0633,
                    215400 : 0.0685,
                    1077550 : 0.0965,
                    5000000 : 0.103,
                    25000000.0 : 0.109],
                .marriedJointly: [
                    0.0 : 0.0597,
                    161550.0 : 0.0633,
                    323200.0 : 0.0685,
                    2155350.0 : 0.0965,
                    5000000.0 : 0.103,
                    25000000.0 : 0.109]],
            .y2020: [
                // These year 2020 rates are approximated (based on 2021 nonprogressive and progressive 2020)
                .single: [
                    0.0 : 0.0609,
                    80650.0 : 0.0641,
                    215400.0 : 0.0685,
                    1077550.0 : 0.0882],
                .marriedJointly: [
                    0.0 : 0.0609,
                    161550.0 : 0.0641,
                    323200.0 : 0.0685,
                    2155350.0 : 0.0882]]
        ]
    }}
}

// new york city rates
extension RawStartingAtToTaxRateMap {
    // NYC
    private static var newYorkCityRates: [TaxYear: [FilingType: [Double:Double]]] { get {
        return [
            .y2021: self.newYorkCityRatesFrom2017to2022,
            .y2020: self.newYorkCityRatesFrom2017to2022
        ]
    }}

    // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
    // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
    // PS: These are full-year resident rates! Part year resident rates might differ
    private static var newYorkCityRatesFrom2017to2022: [FilingType: [Double:Double]] { get {
        return [
            .single: [
                0.0 : 0.03078,
                12000.0 : 0.03762,
                25000.0 : 0.03819,
                50000.0 : 0.03876],
            .marriedJointly: [
                0.0 : 0.03078,
                21600.0 : 0.03762,
                45000.0 : 0.03819,
                90000.0 : 0.03876]
        ]
    }}
}

// California rates
extension RawStartingAtToTaxRateMap {
    // CA
    // see https://www.nerdwallet.com/article/taxes/california-state-tax
    // see https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf
    //
    // Note only valid for incomes of $100,000+
    private static var californiaRates: [TaxYear: [FilingType: [Double:Double]]] { get {
        return [
            .y2021: [
                .single: [
                    0.0 : 0.01,
                    9325.0 : 0.02,
                    22107.0 : 0.04,
                    34892.0 : 0.06,
                    48435.0 : 0.08,
                    61214.0 : 0.093,
                    312686.0 : 0.103,
                    375221.0 : 0.113,
                    625369.0 : 0.123],
                .marriedJointly: [
                    0.0 : 0.01,
                    18650.0 : 0.02,
                    44214.0 : 0.04,
                    69784.0 : 0.06,
                    96870.0 : 0.08,
                    122428.0 : 0.093,
                    625372.0 : 0.103,
                    750442.0 : 0.113,
                    1250738.0 : 0.123]],
            .y2020: [
                .single: [
                    0.0 : 0.01,
                    8932.0 : 0.02,
                    21175.0 : 0.04,
                    33421.0 : 0.06,
                    46394.0 : 0.08,
                    58634.0 : 0.093,
                    299508.0 : 0.103,
                    359407.0 : 0.113,
                    599012.0 : 0.123],
                .marriedJointly: [
                    0.0 : 0.01,
                    17864.0 : 0.02,
                    42350.0 : 0.04,
                    66842.0 : 0.06,
                    92788.0 : 0.08,
                    117268.0 : 0.093,
                    599016.0 : 0.103,
                    718814.0 : 0.113,
                    1198024.0 : 0.123]]
        ]
    }}
}
