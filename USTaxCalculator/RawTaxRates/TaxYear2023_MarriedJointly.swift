//
// TaxYear2023_MarriedJointly.swift
//

enum TaxYear2023_MarriedJointly {
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
                0.0: 0.1,
                22001.0: 0.12,
                89451.0: 0.22,
                190_751.0: 0.24,
                364_201.0: 0.32,
                462_501.0: 0.35,
                693_751.0: 0.37,
            ]),
            // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
            standardDeductions: 0.0,
            // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
            // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
            longtermGainsRates: RawTaxRates(simple: [:]),
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
        CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(simple: [:]), // TBD
            // see https://www.ftb.ca.gov/file/personal/deductions/index.html
            standardDeductions: 0.0 // TBD
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        NewYorkStateTaxRates(
            incomeRates: RawTaxRates(simple: [:]), // TBD
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: 16050.0,
            nonProgressiveIncomeRates: RawTaxRates(simple: [:]), // TBD
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
            // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
            // Note: These are full-year resident rates! Part year resident rates might differ
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
