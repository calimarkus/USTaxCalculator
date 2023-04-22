//
// TaxYear2022_MarriedJointly.swift
//

enum TaxYear2022_MarriedJointly {
    static var taxRates: RawTaxRatesYear {
        RawTaxRatesYear(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    private static var federalRates: FederalTaxRates {
        FederalTaxRates(
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.1,
                20551.0: 0.12,
                83551.0: 0.22,
                178_151.0: 0.24,
                340_101.0: 0.32,
                431_901.0: 0.35,
                647_851.0: 0.37,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets",
            ]),
            standardDeductions: RawStandardDeduction(25900.0, sources: [
                "https://www.bankrate.com/taxes/standard-tax-deduction-amounts/",
            ]),
            longtermGainsRates: RawTaxRates(simple: [83351.0: 0.15, 517_200.0: 0.20], sources: [
                "https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates",
                "https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them",
            ]),
            netInvestmentIncomeRates: RawTaxRates(simple: [250_000.0: 0.038], sources: [
                "https://www.irs.gov/individuals/net-investment-income-tax",
            ]),
            basicMedicareIncomeRates: RawTaxRates(simple: [0.0: 0.0145], sources: [
                "https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers",
            ]),
            additionalMedicareIncomeRates: RawTaxRates(progressive: [0.0: 0.0, 250_000.0: 0.009], sources: [
                "https://www.healthline.com/health/medicare/additional-medicare-tax",
            ])
        )
    }

    /// Note: These are only valid for incomes of $100,000+
    private static var californiaRates: CaliforniaStateTaxRates {
        CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.01,
                20199.0: 0.02,
                47885.0: 0.04,
                75577.0: 0.06,
                104_911.0: 0.08,
                132_591.0: 0.093,
                677_279.0: 0.103,
                812_729.0: 0.113,
                1_354_551.0: 0.123,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/california-state-tax",
                "https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf",
            ]),
            standardDeductions: RawStandardDeduction(10404.0, sources: [
                "https://www.ftb.ca.gov/file/personal/deductions/index.html",
            ])
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            // Rates apply for incomes < $107,650
            incomeRates: RawTaxRates(progressive: [
                0.0: 0.04,
                17150.0: 0.045,
                23600.0: 0.0525,
                27900.0: 0.0585,
                161_550.0: 0.0625,
                323_200.0: 0.0685,
                2_155_350.0: 0.0965,
                5_000_000.0: 0.103,
                25_000_000.0: 0.109,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/new-york-state-tax",
                "https://www.forbes.com/advisor/taxes/new-york-state-tax/",
                "https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51",
            ]),
            standardDeductions: RawStandardDeduction(16050.0, sources: [
                "https://www.tax.ny.gov/pit/file/standard_deductions.htm",
                "https://www.efile.com/new-york-tax-rates-forms-and-brackets/",
            ]),
            // These rates are a fairly rough approximation, mostly based on 2021
            nonProgressiveIncomeRates: RawTaxRates(simple: [
                0.0: 0.0585,
                161_550.0: 0.0633,
                323_200.0: 0.0685,
                2_155_350.0: 0.0965,
                5_000_000.0: 0.103,
                25_000_000.0: 0.109,
            ], sources: [
                "https://www.tax.ny.gov/forms/income_cur_forms.htm",
                "https://www.tax.ny.gov/forms/income_fullyear_forms.htm",
                "https://www.tax.ny.gov/forms/current-forms/it/it201i.htm",
            ]),
            // Note: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: RawTaxRates(progressive: [
                0.0: 0.03078,
                21600.0: 0.03762,
                45000.0: 0.03819,
                90000.0: 0.03876,
            ], sources: [
                "https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67",
                "https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates",
            ])
        )
    }
}
