import Foundation

struct AdvisorRecommendation: Codable {
    let advisorName: String
    let conversationDate: Date
    let conversationDuration: Int // minutes
    let discussionPoints: [String]
    let recommendationText: String
    let holdPercentage: Double
    let sellPercentage: Double

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: conversationDate)
    }

    var formattedDuration: String {
        "\(conversationDuration) min"
    }
}
