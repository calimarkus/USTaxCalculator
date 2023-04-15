//
//

enum TaxYear2023_Single {
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
                0.0: 0.10,
                11001.0: 0.12,
                44726.0: 0.22,
                95376.0: 0.24,
                182101.0: 0.32,
                231251.0: 0.35,
                578126.0: 0.37
            ]),
            // see https://www.bankrate.com/taxes/standard-tax-deduction-amounts/
            standardDeductions: 0.0, // TBD
            // see https://www.nerdwallet.com/article/taxes/capital-gains-tax-rates
            // see https://www.unionbank.com/personal/financial-insights/investing/personal-investing/capital-gains-tax-rates-2021-and-how-to-minimize-them
            longtermGainsRates: RawTaxRates(simple: [:]),
            // see https://www.irs.gov/individuals/net-investment-income-tax
            netInvestmentIncomeRates: RawTaxRates(simple: [200000.0: 0.038]),
            // see https://www.indeed.com/hire/c/info/medicare-taxes-an-overview-for-employers
            basicMedicareIncomeRates: RawTaxRates(simple: [0.0: 0.0145]),
            // see https://www.healthline.com/health/medicare/additional-medicare-tax
            additionalMedicareIncomeRates: RawTaxRates(progressive: [0.0: 0.0, 200000.0: 0.009])
        )
    }

    // CA
    // see https://www.nerdwallet.com/article/taxes/california-state-tax
    // see https://www.ftb.ca.gov/forms/2020/2020-California-Tax-Rate-Schedules.pdf
    //
    // Note: These are only valid for incomes of $100,000+
    private static var californiaRates: CaliforniaStateTaxRates {
        return CaliforniaStateTaxRates(
            incomeRates: RawTaxRates(simple: [:]), // TBD
            // see https://www.ftb.ca.gov/file/personal/deductions/index.html
            standardDeductions: 0.0 // TBD
        )
    }

    private static var newYorkRates: NewYorkStateTaxRates {
        return NewYorkStateTaxRates(
            incomeRates: RawTaxRates(simple: [:]), // TBD
            // see https://www.tax.ny.gov/pit/file/standard_deductions.htm
            // see https://www.efile.com/new-york-tax-rates-forms-and-brackets/
            standardDeductions: 8000.0,
            nonProgressiveIncomeRates: RawTaxRates(simple: [:]), // TBD
            // see https://www.tax.ny.gov/pdf/current_forms/it/it201i.pdf#page=67
            // see https://answerconnect.cch.com/document/jyc0109013e2c83c2542d/state/explanations/new-york-city/nyc-tax-rates-blended-nyc-tax-rates
            // PS: These are full-year resident rates! Part year resident rates might differ
            // Rates apply for incomes > $65,000
            newYorkCityRates: RawTaxRates(progressive: [
                0.0: 0.03078,
                12000.0: 0.03762,
                25000.0: 0.03819,
                50000.0: 0.03876
            ])
        )
    }
}
