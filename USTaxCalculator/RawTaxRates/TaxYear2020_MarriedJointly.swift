//
// TaxYear2020_MarriedJointly.swift
//

enum TaxYear2020_MarriedJointly {
    static var taxRates: RawTaxRatesYear {
        RawTaxRatesYear(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    private static var federalRates: FederalTaxRates {
        FederalTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.10,
                19750.0: 0.12,
                80250.0: 0.22,
                171_050.0: 0.24,
                326_600.0: 0.32,
                414_700.0: 0.35,
                622_050.0: 0.37,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets",
            ]),
            standardDeductions: RawStandardDeduction(24800.0, sources: [
                "https://www.bankrate.com/taxes/standard-tax-deduction-amounts/",
            ]),
            longtermGainsRates: RawTaxRates(.simple, [80000.0: 0.15, 496_600.0: 0.20], sources: [
                "https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates",
                "https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them",
            ]),
            netInvestmentIncomeRates: RawTaxRates(.simple, [250_000.0: 0.038], sources: [
                "https://www.irs.gov/individuals/net-investment-income-tax",
            ]),
            basicMedicareIncomeRates: RawTaxRates(.simple, [0.0: 0.0145], sources: [
                "https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers",
            ]),
            additionalMedicareIncomeRates: RawTaxRates(.progressive, [0.0: 0.0, 250_000.0: 0.009], sources: [
                "https://www.healthline.com/health/medicare/additional-medicare-tax",
            ])
        )
    }

    private static var californiaRates: CaliforniaStateTaxRates {
        CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.01,
                17864.0: 0.02,
                42350.0: 0.04,
                66842.0: 0.06,
                92788.0: 0.08,
                117_268.0: 0.093,
                599_016.0: 0.103,
                718_814.0: 0.113,
                1_198_024.0: 0.123,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/california-state-tax",
                "https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf",
            ]),
            standardDeductions: RawStandardDeduction(9202.0, sources: [
                "https://www.ftb.ca.gov/about-ftb/newsroom/tax-news/november-2020/standard-deductions-exemption-amounts-and-tax-rates-for-2020-tax-year.html",
            ]),
            // CA doesn't use progressive rates for incomes lower or equal to 100,000
            isEligableForLowIncomeRates: { taxableIncome in
                taxableIncome <= 100_000
            },
            lowIncomeRates: RawTaxRates(.interpolated, [
                0: 0.01,
                5000: 0.01,
                10000: 0.011,
                20000: 0.0155,
                30000: 0.023,
                40000: 0.030,
                50000: 0.038,
                60000: 0.045,
                70000: 0.052,
                80000: 0.057,
                90000: 0.061,
                100_000: 0.064,
            ], sources: [
                "https://www.ftb.ca.gov/forms/2020/2020-540-taxtable.pdf",
            ])
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.04,
                17150.0: 0.045,
                23600.0: 0.0525,
                27900.0: 0.059,
                43000.0: 0.0609,
                161_550.0: 0.0641,
                323_200.0: 0.0685,
                2_155_350.0: 0.0882,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/new-york-state-tax",
                "https://www.forbes.com/advisor/taxes/new-york-state-tax/",
                "https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51",
            ]),
            standardDeductions: RawStandardDeduction(16050.0, sources: [
                "https://www.tax.ny.gov/pit/file/standard_deductions.htm",
                "https://www.efile.com/new-york-tax-rates-forms-and-brackets/",
            ]),
            // new york doesn't use progressive rates for incomes higher than $107,650
            isEligableForHighIncomeRates: { taxableIncome in
                taxableIncome > 107_650
            },
            // This is simplified - more math is involved to do these properly as the source link shows.
            // That rate changes for every increment of 50k, partly based on the progressive rate, which is rather complex.
            // The proper fix is to implement the full tax computation worksheets.
            //
            // These year 2020 rates are approximated (based on 2021 nonprogressive and progressive 2020)
            highIncomeRates:
            RawTaxRates(.simple, [
                0.0: 0.0609,
                161_550.0: 0.0641,
                323_200.0: 0.0685,
                2_155_350.0: 0.0882,
            ], sources: [
                "https://www.tax.ny.gov/forms/income_cur_forms.htm",
                "https://www.tax.ny.gov/forms/income_fullyear_forms.htm",
                "https://www.tax.ny.gov/forms/current-forms/it/it201i.htm",
            ]),
            // Note: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: RawTaxRates(.progressive, [
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
