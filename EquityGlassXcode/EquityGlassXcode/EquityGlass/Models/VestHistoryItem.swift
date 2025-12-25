import Foundation

struct VestHistoryItem: Identifiable, Codable {
    let id: UUID
    let vestDate: Date
    let shares: Int
    let vestPrice: Double
    let currentPrice: Double?
    let soldPrice: Double?
    let soldDate: Date?
    let lotNumber: String?

    // Status
    var status: VestStatus {
        if soldPrice != nil {
            return .sold
        }
        return .held
    }

    // P&L calculations
    var gainLoss: Double {
        let price = soldPrice ?? currentPrice ?? vestPrice
        return (price - vestPrice) * Double(shares)
    }

    var gainLossPercentage: Double {
        let price = soldPrice ?? currentPrice ?? vestPrice
        return ((price - vestPrice) / vestPrice) * 100
    }

    var isPositive: Bool {
        gainLoss > 0
    }

    enum VestStatus: String, Codable {
        case held = "Held"
        case sold = "Sold"
    }
}
