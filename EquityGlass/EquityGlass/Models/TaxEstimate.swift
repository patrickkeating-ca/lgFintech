import Foundation

struct TaxEstimate: Codable {
    let grossValue: Double
    let federalTax: Double
    let federalRate: Double
    let stateTax: Double
    let stateRate: Double
    let ficaTax: Double
    let ficaRate: Double

    var netValue: Double {
        grossValue - federalTax - stateTax - ficaTax
    }

    var totalTax: Double {
        federalTax + stateTax + ficaTax
    }

    var effectiveRate: Double {
        totalTax / grossValue
    }
}
