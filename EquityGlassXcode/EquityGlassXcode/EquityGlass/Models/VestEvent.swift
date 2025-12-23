import Foundation

struct VestEvent: Identifiable, Codable {
    let id: UUID
    let vestDate: Date
    let companyName: String
    let sharesVesting: Int
    let ticker: String
    let stockPrice: Double
    let stockPriceLastUpdated: Date
    let estimatedValue: Double
    let advisorRecommendation: AdvisorRecommendation?
    let taxEstimate: TaxEstimate?

    // Computed properties
    var daysUntilVest: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: vestDate)
        return max(0, components.day ?? 0)
    }

    var hasVested: Bool {
        vestDate < Date()
    }

    var sharePrice: Double {
        estimatedValue / Double(sharesVesting)
    }

    // Split calculations based on advisor recommendation
    var holdShares: Int {
        guard let recommendation = advisorRecommendation else { return 0 }
        return Int(Double(sharesVesting) * recommendation.holdPercentage)
    }

    var sellShares: Int {
        guard let recommendation = advisorRecommendation else { return 0 }
        return Int(Double(sharesVesting) * recommendation.sellPercentage)
    }

    var holdValue: Double {
        Double(holdShares) * sharePrice
    }

    var sellValue: Double {
        Double(sellShares) * sharePrice
    }
}
