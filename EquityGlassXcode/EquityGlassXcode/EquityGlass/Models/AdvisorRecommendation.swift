import Foundation

struct AdvisorRecommendation: Codable {
    let advisorName: String
    let advisorFullName: String?
    let advisorTitle: String?
    let advisorCredentials: String?
    let advisorCompany: String?
    let advisorPhone: String?
    let advisorPhotoAsset: String? // Asset name for advisor photo (e.g., "AdvisorAvatar", "SofiaPatelAvatar")
    let conversationDate: Date
    let conversationDuration: Int // minutes
    let discussionPoints: [String]
    let recommendationText: String
    let holdPercentage: Double
    let sellPercentage: Double

    var displayName: String {
        advisorFullName ?? advisorName
    }

    var fullCredentials: String {
        var result = displayName
        if let credentials = advisorCredentials {
            result += ", \(credentials)"
        }
        return result
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: conversationDate)
    }

    var formattedDuration: String {
        "\(conversationDuration) min"
    }
}
