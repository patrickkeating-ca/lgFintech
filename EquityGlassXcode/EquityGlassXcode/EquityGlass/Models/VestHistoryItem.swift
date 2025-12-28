import Foundation

enum VestType: String, Codable {
    case RSU = "RSU"
    case ESPP = "ESPP"
    case PSU = "PSU"
}

struct VestHistoryItem: Identifiable, Codable {
    let id: UUID
    let vestDate: Date
    let shares: Int
    let vestPrice: Double
    let currentPrice: Double?
    let soldPrice: Double?
    let soldDate: Date?
    let lotNumber: String?
    let type: VestType?

    // Split sale support (for partial sales like 70H/30S)
    let sharesHeld: Int?
    let sharesSold: Int?
    let soldPortionPrice: Double?
    let soldPortionDate: Date?

    // Status
    var status: VestStatus {
        // If we have split data, check if any shares were sold
        if let sharesSold = sharesSold, sharesSold > 0 {
            // If shares held exists and is greater than 0, it's a split
            if let sharesHeld = sharesHeld, sharesHeld > 0 {
                return .split
            }
            // All shares sold
            return .sold
        }
        // Legacy: check soldPrice
        if soldPrice != nil {
            return .sold
        }
        return .held
    }

    // P&L calculations (legacy - for fully sold or fully held)
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

    // Realized G/L (for sold portion)
    var realizedGainLoss: Double? {
        if let sharesSold = sharesSold, sharesSold > 0, let soldPrice = soldPortionPrice {
            return (soldPrice - vestPrice) * Double(sharesSold)
        }
        // Legacy: if fully sold
        if status == .sold, let soldPrice = soldPrice {
            return (soldPrice - vestPrice) * Double(shares)
        }
        return nil
    }

    // Unrealized G/L (for held portion)
    var unrealizedGainLoss: Double? {
        if let sharesHeld = sharesHeld, sharesHeld > 0, let currentPrice = currentPrice {
            return (currentPrice - vestPrice) * Double(sharesHeld)
        }
        // Legacy: if fully held
        if status == .held, let currentPrice = currentPrice {
            return (currentPrice - vestPrice) * Double(shares)
        }
        return nil
    }

    // Split display (e.g., "70H/30S")
    var splitDisplay: String {
        if let sharesHeld = sharesHeld, let sharesSold = sharesSold {
            let totalShares = sharesHeld + sharesSold
            let heldPct = Int(round(Double(sharesHeld) / Double(totalShares) * 100))
            let soldPct = Int(round(Double(sharesSold) / Double(totalShares) * 100))
            return "\(heldPct)H/\(soldPct)S"
        }
        // Legacy
        if status == .sold {
            return "100S"
        } else {
            return "100H"
        }
    }

    enum VestStatus: String, Codable {
        case held = "Held"
        case sold = "Sold"
        case split = "Split"
    }
}
