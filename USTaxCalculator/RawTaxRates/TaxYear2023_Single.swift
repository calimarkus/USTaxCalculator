//
// TaxYear2023_Single.swift
//

enum TaxYear2023_Single {
    static var taxRates: RawTaxRatesGroup {
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

    private static var californiaRates: CaliforniaStateTaxRates {
        CaliforniaStateTaxRates(
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
            // CA doesn't use progressive rates for incomes lower or equal to 100,000
            isEligableForLowIncomeRates: { taxableIncome in
                taxableIncome <= 100_000
            },
            lowIncomeRates: RawTaxRates(.interpolated, [:], sources: []), // TBD
            mentalHealthRates: RawTaxRates(.progressive, [0.0: 0.0, 1_000_000.0: 0.01], sources: [
                "https://www.mentalhealthca.org/faq-1",
            ])
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            incomeRates: RawTaxRates(.simple, [:]), // TBD
            standardDeductions: RawStandardDeduction(8000.0, sources: [
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
