//
// RawTaxRates2021_MarriedJointly.swift
//

extension RawTaxRates2021: RawTaxRatesYear {}

public struct RawTaxRates2021 {
    public init() {}

    public var marriedJointlyRates: RawTaxRatesGroup {
        RawTaxRatesGroup(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    fileprivate static var federalRates: RawFederalTaxRates {
        RawFederalTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.1,
                19900.0: 0.12,
                81050.0: 0.22,
                172_750.0: 0.24,
                329_850.0: 0.32,
                418_850.0: 0.35,
                628_300.0: 0.37,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets",
            ]),
            standardDeductions: RawStandardDeduction(25100.0, sources: [
                "https://www.bankrate.com/taxes/standard-tax-deduction-amounts/",
            ]),
            longtermGainsRates: RawTaxRates(.simple, [80800.0: 0.15, 501_600.0: 0.20], sources: [
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

    /// Note: These are only valid for incomes of $100,000+
    fileprivate static var californiaRates: RawCaliforniaStateTaxRates {
        RawCaliforniaStateTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.01,
                18650.0: 0.02,
                44214.0: 0.04,
                69784.0: 0.06,
                96870.0: 0.08,
                122_428.0: 0.093,
                625_372.0: 0.103,
                750_442.0: 0.113,
                1_250_738.0: 0.123,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/california-state-tax",
                "https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf",
            ]),
            standardDeductions: RawStandardDeduction(9606.0, sources: [
                "https://www.ftb.ca.gov/file/personal/deductions/index.html",
            ]),
            // CA doesn't use progressive rates for incomes lower or equal to $100,000
            lowIncomeRatesLimit: 100_000,
            lowIncomeRates: RawTaxRates(.interpolated, [
                0: 0.01,
                5000: 0.01,
                10000: 0.011,
                20000: 0.015,
                30000: 0.022,
                40000: 0.029,
                50000: 0.037,
                60000: 0.043,
                70000: 0.050,
                80000: 0.056,
                90000: 0.060,
                100_000: 0.063,
            ], sources: [
                "https://www.ftb.ca.gov/forms/2021/2021-540-taxtable.pdf",
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
                17150.0: 0.045,
                23600.0: 0.0525,
                27900.0: 0.059,
                43000.0: 0.0597,
                161_550.0: 0.0633,
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
            highIncomeRateThreshhold: 107_650,
            // This is simplified - more math is involved to do these properly as the source link shows.
            // That rate changes for every increment of 50k, partly based on the progressive rate, which is rather complex.
            // The proper fix is to implement the full tax computation worksheets.
            highIncomeRates: RawTaxRates(.simple, [
                0.0: 0.0597,
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
