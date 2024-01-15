//
// RawTaxRates2023_Single.swift
//

public extension RawTaxRates2023 {
    var singleRates: RawTaxRatesGroup {
        RawTaxRatesGroup(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    fileprivate static var federalRates: RawFederalTaxRates {
        RawFederalTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.10,
                11001.0: 0.12,
                44726.0: 0.22,
                95376.0: 0.24,
                182_101.0: 0.32,
                231_251.0: 0.35,
                578_126.0: 0.37,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets",
            ]),
            standardDeductions: RawStandardDeduction(13850.0, sources: [
                "https://www.bankrate.com/taxes/standard-tax-deduction-amounts/",
            ]),
            longtermGainsRates: RawTaxRates(.simple, [44626.0: 0.15, 492_301.0: 0.20], sources: [
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

    fileprivate static var californiaRates: RawCaliforniaStateTaxRates {
        RawCaliforniaStateTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.01,
                10413.0: 0.02,
                24685.0: 0.04,
                38960.0: 0.06,
                54082.0: 0.08,
                68351.0: 0.093,
                349_138.0: 0.103,
                418_962.0: 0.113,
                698_272.0: 0.123,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/california-state-tax",
                "https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf",
            ]),
            standardDeductions: RawStandardDeduction(5363.0, sources: [
                "https://www.ftb.ca.gov/file/personal/deductions/index.html",
            ]),
            lowIncomeRatesLimit: 100_000,
            lowIncomeRates: RawTaxRates(.interpolated, [
                0: 0.00001,
                5000: 0.00050,
                10000: 0.00100,
                20000: 0.00296,
                30000: 0.00605,
                40000: 0.01023,
                50000: 0.01623,
                60000: 0.02341,
                70000: 0.03163,
                80000: 0.04093,
                90000: 0.05023,
                100_000: 0.05951,
            ], sources: [
                "https://www.ftb.ca.gov/forms/2023/2023-540-taxtable.pdf",
            ]),
            mentalHealthRates: RawTaxRates(.progressive, [0.0: 0.0, 1_000_000.0: 0.01], sources: [
                "https://www.mentalhealthca.org/faq-1",
            ])
        )
    }

    fileprivate static var newYorkRates: RawNewYorkStateTaxRates {
        RawNewYorkStateTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.04,
                8500.0: 0.045,
                11700.0: 0.0525,
                13900.0: 0.055,
                80650.0: 0.06,
                215_400.0: 0.0685,
                1_077_550.0: 0.0965,
                5_000_000.0: 0.103,
                25_000_000.0: 0.109,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/new-york-state-tax",
            ]),
            standardDeductions: RawStandardDeduction(8000.0, sources: [
                "https://www.tax.ny.gov/pit/file/standard_deductions.htm",
                "https://www.efile.com/new-york-tax-rates-forms-and-brackets/",
            ]),
            highIncomeRateThreshhold: 107_650,
            // These rates are a fairly rough approximation, mostly based on 2021
            highIncomeRates: RawTaxRates(.simple, [
                0.0: 0.0625,
                215_400: 0.0685,
                1_077_550: 0.0965,
                5_000_000: 0.103,
                25_000_000.0: 0.109,
            ], sources: [
                "https://www.tax.ny.gov/forms/current-forms/it/it201i.htm#tax-computation",
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
