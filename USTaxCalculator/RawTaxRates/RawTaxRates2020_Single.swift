//
// RawTaxRates2020_Single.swift
//

extension RawTaxRates2020 {
    static var singleRates: RawTaxRatesGroup {
        RawTaxRatesGroup(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    private static var federalRates: FederalTaxRates {
        FederalTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.10,
                9875.0: 0.12,
                40125.0: 0.22,
                85525.0: 0.24,
                163_300.0: 0.32,
                207_350.0: 0.35,
                518_400.0: 0.37,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets",
            ]),
            standardDeductions: RawStandardDeduction(12400.0, sources: [
                "https://www.bankrate.com/taxes/standard-tax-deduction-amounts/",
            ]),
            longtermGainsRates: RawTaxRates(.simple, [40000.0: 0.15, 441_450.0: 0.20], sources: [
                "https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates",
                "https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them",
            ]),
            netInvestmentIncomeRates: RawTaxRates(.simple, [200_000.0: 0.038], sources: [
                "https://www.irs.gov/individuals/net-investment-income-tax",
            ]),
            basicMedicareIncomeRates: RawTaxRates(.simple, [0.0: 0.0145], sources: [
                "https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers",
            ]),
            additionalMedicareIncomeRates: RawTaxRates(.progressive, [0.0: 0.0, 200_000.0: 0.009], sources: [
                "https://www.healthline.com/health/medicare/additional-medicare-tax",
            ])
        )
    }

    private static var californiaRates: CaliforniaStateTaxRates {
        CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.01,
                8932.0: 0.02,
                21175.0: 0.04,
                33421.0: 0.06,
                46394.0: 0.08,
                58634.0: 0.093,
                299_508.0: 0.103,
                359_407.0: 0.113,
                599_012.0: 0.123,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/california-state-tax",
                "https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf",
            ]),
            standardDeductions: RawStandardDeduction(4601.0, sources: [
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
            ]),
            mentalHealthRates: RawTaxRates(.progressive, [0.0: 0.0, 1_000_000.0: 0.01], sources: [
                "https://www.mentalhealthca.org/faq-1",
            ])
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            // Rates apply for incomes < $107,650
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.04,
                8500.0: 0.045,
                11700.0: 0.0525,
                13900.0: 0.059,
                21400.0: 0.0609,
                80650.0: 0.0641,
                215_400.0: 0.0685,
                1_077_550.0: 0.0882,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/new-york-state-tax",
                "https://www.forbes.com/advisor/taxes/new-york-state-tax/",
                "https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=51",
            ]),
            standardDeductions: RawStandardDeduction(8000.0, sources: [
                "https://www.tax.ny.gov/pit/file/standard_deductions.htm",
                "https://www.efile.com/new-york-tax-rates-forms-and-brackets/",
            ]),
            // new york doesn't use progressive rates for incomes higher than $107,650
            isEligableForHighIncomeRates: { taxableIncome in
                taxableIncome > 107_650
            },
            //
            // This is simplified - more math is involved to do these properly as the source link shows.
            // That rate changes for every increment of 50k, partly based on the progressive rate, which is rather complex.
            // The proper fix is to implement the full tax computation worksheets.
            //
            // These year 2020 rates are approximated (based on 2021 nonprogressive and progressive 2020)
            highIncomeRates:
            RawTaxRates(.simple, [
                0.0: 0.0609,
                80650.0: 0.0641,
                215_400.0: 0.0685,
                1_077_550.0: 0.0882,
            ], sources: [
                "https://www.tax.ny.gov/forms/income_cur_forms.htm",
                "https://www.tax.ny.gov/forms/income_fullyear_forms.htm",
                "https://www.tax.ny.gov/forms/current-forms/it/it201i.htm",
            ]),
            // Note: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: RawTaxRates(.progressive, [
                0.0: 0.03078,
                12000.0: 0.03762,
                25000.0: 0.03819,
                50000.0: 0.03876,
            ], sources: [
                "https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67",
                "https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates",
            ])
        )
    }
}
