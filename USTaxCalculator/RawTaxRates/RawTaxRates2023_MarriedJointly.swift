//
// RawTaxRates2023_MarriedJointly.swift
//

extension RawTaxRates2023: RawTaxRatesYear {}

struct RawTaxRates2023 {
    var marriedJointlyRates: RawTaxRatesGroup {
        RawTaxRatesGroup(
            federalRates: Self.federalRates,
            californiaRates: Self.californiaRates,
            newYorkRates: Self.newYorkRates
        )
    }

    private static var federalRates: FederalTaxRates {
        FederalTaxRates(
            incomeRates: RawTaxRates(.progressive, [
                0.0: 0.1,
                22001.0: 0.12,
                89451.0: 0.22,
                190_751.0: 0.24,
                364_201.0: 0.32,
                462_501.0: 0.35,
                693_751.0: 0.37,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/federal-income-tax-brackets",
            ]),
            standardDeductions: RawStandardDeduction(27700.0, sources: [
                "https://www.bankrate.com/taxes/standard-tax-deduction-amounts/",
            ]),
            longtermGainsRates: RawTaxRates(.simple, [89251.0: 0.15, 553_851.0: 0.20], sources: [
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
                20825.0: 0.02,
                49369.0: 0.04,
                77919.0: 0.06,
                108_163.0: 0.08,
                136_701.0: 0.093,
                698_275.0: 0.103,
                837_923.0: 0.113,
                1_369_543.0: 0.123,
            ], sources: [
                "https://www.nerdwallet.com/article/taxes/california-state-tax",
                "https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf",
            ]), // TBD
            standardDeductions: RawStandardDeduction(10726.0, sources: [
                "https://www.ftb.ca.gov/file/personal/deductions/index.html",
            ]),
            lowIncomeRatesLimit: 100_000,
            lowIncomeRates: RawTaxRates(.interpolated, [:], sources: []), // TBD
            mentalHealthRates: RawTaxRates(.progressive, [0.0: 0.0, 1_000_000.0: 0.01], sources: [
                "https://www.mentalhealthca.org/faq-1",
            ])
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            incomeRates: RawTaxRates(.simple, [:]), // TBD
            standardDeductions: RawStandardDeduction(16050.0, sources: [
                "https://www.tax.ny.gov/pit/file/standard_deductions.htm",
                "https://www.efile.com/new-york-tax-rates-forms-and-brackets/",
            ]),
            // new york doesn't use progressive rates for incomes higher than $107,650
            isEligableForHighIncomeRates: { taxableIncome in
                taxableIncome > 107_650
            },
            highIncomeRates: RawTaxRates(.simple, [:]), // TBD
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
