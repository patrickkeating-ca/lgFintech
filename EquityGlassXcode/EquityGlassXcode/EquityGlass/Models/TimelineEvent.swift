import Foundation

enum EventType: String, Codable {
    case vest = "vest"
    case tradeWindow = "tradeWindow"
    case cancelPeriod = "cancelPeriod"
    case taxDeadline = "taxDeadline"
    case esppPurchase = "esppPurchase"
    case performanceReview = "performanceReview"
    case blackoutPeriod = "blackoutPeriod"
    case advisorMeeting = "advisorMeeting"

    var icon: String {
        switch self {
        case .vest: return "calendar.badge.clock"
        case .tradeWindow: return "chart.line.uptrend.xyaxis"
        case .cancelPeriod: return "xmark.circle"
        case .taxDeadline: return "doc.text"
        case .esppPurchase: return "cart"
        case .performanceReview: return "star.circle"
        case .blackoutPeriod: return "lock.circle"
        case .advisorMeeting: return "person.2"
        }
    }

    var color: String {
        switch self {
        case .vest: return "blue"
        case .tradeWindow: return "green"
        case .cancelPeriod: return "orange"
        case .taxDeadline: return "red"
        case .esppPurchase: return "purple"
        case .performanceReview: return "yellow"
        case .blackoutPeriod: return "gray"
        case .advisorMeeting: return "cyan"
        }
    }
}

struct TimelineEvent: Identifiable, Codable {
    let id: UUID
    let date: Date
    let type: EventType
    let title: String
    let description: String
    let actionable: Bool

    var daysUntil: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: date)
        return max(0, components.day ?? 0)
    }

    var isPast: Bool {
        date < Date()
    }
}
