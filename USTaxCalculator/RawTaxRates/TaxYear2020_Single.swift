//
// TaxYear2020_Single.swift
//

enum TaxYear2020_Single {
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
                9875.0: 0.12,
                40125.0: 0.22,
                85525.0: 0.24,
                163_300.0: 0.32,
                207_350.0: 0.35,
                518_400.0: 0.37,
            ]),
            // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
            standardDeductions: 12400.0,
            // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
            // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
            longtermGainsRates: RawTaxRates(simple: [441_450.0: 0.20, 40000.0: 0.15]),
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
                8932.0: 0.02,
                21175.0: 0.04,
                33421.0: 0.06,
                46394.0: 0.08,
                58634.0: 0.093,
                299_508.0: 0.103,
                359_407.0: 0.113,
                599_012.0: 0.123,
            ]),
            // see https://www.ftb.ca.gov/about-ftb/newsroom/tax-news/november-2020/standard-deductions-exemption-amounts-and-tax-rates-for-2020-tax-year.html
            standardDeductions: 4601.0
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
                13900.0: 0.059,
                21400.0: 0.0609,
                80650.0: 0.0641,
                215_400.0: 0.0685,
                1_077_550.0: 0.0882,
            ]),
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: 8000.0,
            // see https://www.tax.ny.gov/forms/income_cur_forms.htm
            // see https://www.tax.ny.gov/forms/income_fullyear_forms.htm
            // see https://www.tax.ny.gov/forms/current-forms/it/it201i.htm (IT-201-I instructions)
            //
            // This is simplified - more math is involved to do these properly as above link shows.
            // That rate changes for every increment of 50k, partly based on the progressive rate, which is rather complex.
            // The proper fix is to implement the full tax computation worksheets.
            //
            // Rates apply for incomes >= $107,650
            nonProgressiveIncomeRates:
            // These year 2020 rates are approximated (based on 2021 nonprogressive and progressive 2020)
            RawTaxRates(simple: [
                0.0: 0.0609,
                80650.0: 0.0641,
                215_400.0: 0.0685,
                1_077_550.0: 0.0882,
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
