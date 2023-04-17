//
// TaxYear2022_Single.swift
//

enum TaxYear2022_Single {
    static var taxRates: RawTaxRatesYear {
        RawTaxRatesYear(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    private static var federalRates: FederalTaxRates {
        FederalTaxRates(
            // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.10,
                10276.0: 0.12,
                41776.0: 0.22,
                89076.0: 0.24,
                170_051.0: 0.32,
                215_951.0: 0.35,
                539_901.0: 0.37,
            ]),
            // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
            standardDeductions: 12950.0,
            // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
            // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
            longtermGainsRates: RawTaxRates(simple: [459_751.0: 0.20, 41676.0: 0.15]),
            // see https://www.irs.gov/individuals/net-investment-income-tax
            netInvestmentIncomeRates: RawTaxRates(simple: [200_000.0: 0.038]),
            // see https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers
            basicMedicareIncomeRates: RawTaxRates(simple: [0.0: 0.0145]),
            // see https://www.healthline.com/health/medicare/additional-medicare-tax
            additionalMedicareIncomeRates: RawTaxRates(progressive: [0.0: 0.0, 200_000.0: 0.009])
        )
    }

    // CA
    // see https://www.nerdwallet.com/article/taxes/california-state-tax
    // see https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf
    //
    // Note: These are only valid for incomes of $100,000+
    private static var californiaRates: CaliforniaStateTaxRates {
        CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.01,
                10100.0: 0.02,
                23943.0: 0.04,
                37789.0: 0.06,
                52456.0: 0.08,
                66296.0: 0.093,
                338_640.0: 0.103,
                406_365.0: 0.113,
                677_276.0: 0.123,
            ]),
            // see https://www.ftb.ca.gov/file/personal/deductions/index.html
            standardDeductions: 5202.0
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            // see https://www.nerdwallet.com/article/taxes/new-york-state-tax
            // see https://www.forbes.com/advisor/taxes/new-york-state-tax/
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51
            // Rates apply for incomes < $107,650
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.04,
                8500.0: 0.045,
                11700.0: 0.0525,
                13900.0: 0.0585,
                80650.0: 0.0625,
                215_400.0: 0.0685,
                1_077_550.0: 0.0965,
                5_000_000.0: 0.103,
                25_000_000.0: 0.109,
            ]),
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: 8000.0,
            // These rates are a fairly rough approximation, mostly based on 2021
            nonProgressiveIncomeRates: RawTaxRates(simple: [
                0.0: 0.0625,
                215_400: 0.0685,
                1_077_550: 0.0965,
                5_000_000: 0.103,
                25_000_000.0: 0.109,
            ]),
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
            // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
            // Note: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: RawTaxRates(progressive: [
                0.0: 0.03078,
                12000.0: 0.03762,
                25000.0: 0.03819,
                50000.0: 0.03876,
            ])
        )
    }
}
