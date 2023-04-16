//
//

enum TaxYear2021_MarriedJointly {
    static var taxRates: RawTaxRatesYear {
        return RawTaxRatesYear(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    private static var federalRates: FederalTaxRates {
        return FederalTaxRates(
            // see https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.1,
                19900.0: 0.12,
                81050.0: 0.22,
                172_750.0: 0.24,
                329_850.0: 0.32,
                418_850.0: 0.35,
                628_300.0: 0.37,
            ]),
            // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
            standardDeductions: 25100.0,
            // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
            // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
            longtermGainsRates: RawTaxRates(simple: [501_600.0: 0.20, 80800.0: 0.15]),
            // see https://www.irs.gov/individuals/net-investment-income-tax
            netInvestmentIncomeRates: RawTaxRates(simple: [250_000.0: 0.038]),
            // see https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers
            basicMedicareIncomeRates: RawTaxRates(simple: [0.0: 0.0145]),
            // see https://www.healthline.com/health/medicare/additional-medicare-tax
            additionalMedicareIncomeRates: RawTaxRates(progressive: [0.0: 0.0, 250_000.0: 0.009])
        )
    }

    // CA
    // see https://www.nerdwallet.com/article/taxes/california-state-tax
    // see https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf
    //
    // Note: These are only valid for incomes of $100,000+
    private static var californiaRates: CaliforniaStateTaxRates {
        return CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.01,
                18650.0: 0.02,
                44214.0: 0.04,
                69784.0: 0.06,
                96870.0: 0.08,
                122_428.0: 0.093,
                625_372.0: 0.103,
                750_442.0: 0.113,
                1_250_738.0: 0.123,
            ]),
            // see https://www.ftb.ca.gov/file/personal/deductions/index.html
            standardDeductions: 9606.0
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        return NewYorkStateTaxRates(
            // see https://www.nerdwallet.com/article/taxes/new-york-state-tax
            // see https://www.forbes.com/advisor/taxes/new-york-state-tax/
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51
            // Rates apply for incomes < $107,650
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.04,
                17150.0: 0.045,
                23600.0: 0.0525,
                27900.0: 0.059,
                43000.0: 0.0597,
                161_550.0: 0.0633,
                323_200.0: 0.0685,
                2_155_350.0: 0.0965,
                5_000_000.0: 0.103,
                25_000_000.0: 0.109,
            ]),
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: 16050.0,
            // see https://www.tax.ny.gov/forms/income_cur_forms.htm
            // see https://www.tax.ny.gov/forms/income_fullyear_forms.htm
            // see https://www.tax.ny.gov/forms/current-forms/it/it201i.htm (IT-201-I instructions)
            //
            // This is simplified - more math is involved to do these properly as above link shows.
            // That rate changes for every increment of 50k, partly based on the progressive rate, which is rather complex.
            // The proper fix is to implement the full tax computation worksheets.
            //
            // Rates apply for incomes >= $107,650
            nonProgressiveIncomeRates: RawTaxRates(simple: [
                0.0: 0.0597,
                161_550.0: 0.0633,
                323_200.0: 0.0685,
                2_155_350.0: 0.0965,
                5_000_000.0: 0.103,
                25_000_000.0: 0.109,
            ]),
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
            // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
            // PS: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: RawTaxRates(progressive: [
                0.0: 0.03078,
                21600.0: 0.03762,
                45000.0: 0.03819,
                90000.0: 0.03876,
            ])
        )
    }
}