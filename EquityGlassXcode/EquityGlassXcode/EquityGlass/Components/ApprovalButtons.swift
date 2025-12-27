import SwiftUI

struct ApprovalButtons: View {
    let vest: VestEvent
    let onApprove: () -> Void
    let onRequestChanges: () -> Void

    // Determine if this is a premium tier (has Request Changes option)
    var isPremiumTier: Bool {
        // Premium tier users have advisor phone number (direct line)
        vest.advisorRecommendation?.advisorPhone != nil
    }

    var body: some View {
        VStack(spacing: 12) {
            // Primary CTA: Review and Approve Plan
            Button(action: onApprove) {
                Text("Review and Approve Plan")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.green)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Secondary CTA: Request Changes (Premium tier only - Alex)
            if isPremiumTier {
                Button(action: onRequestChanges) {
                    Text("Request Changes")
                        .font(.body)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.15))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Premium tier (Alex - has phone)
        ApprovalButtons(
            vest: VestEvent(
                id: UUID(),
                vestDate: Date(),
                companyName: "Steamboat Co",
                sharesVesting: 3430,
                ticker: "STBT",
                stockPrice: 112.18,
                stockPriceLastUpdated: Date(),
                estimatedValue: 384777.40,
                advisorRecommendation: AdvisorRecommendation(
                    advisorName: "Fred",
                    advisorFullName: "Fred Amsden",
                    advisorTitle: "Senior Wealth Advisor",
                    advisorCredentials: "CFP®",
                    advisorCompany: "Schwab Private Client",
                    advisorPhone: "(650) 555-1212",
                    advisorPhotoAsset: "AdvisorAvatar",
                    conversationDate: Date(),
                    conversationDuration: 22,
                    discussionPoints: [],
                    recommendationText: "Execute 70/30 split",
                    holdPercentage: 0.70,
                    sellPercentage: 0.30
                ),
                taxEstimate: nil,
                timelineEvents: nil,
                vestHistory: nil
            ),
            onApprove: { print("Approve tapped") },
            onRequestChanges: { print("Request changes tapped") }
        )

        // Standard tier (Marcus - no phone)
        ApprovalButtons(
            vest: VestEvent(
                id: UUID(),
                vestDate: Date(),
                companyName: "Steamboat Co",
                sharesVesting: 600,
                ticker: "STBT",
                stockPrice: 112.18,
                stockPriceLastUpdated: Date(),
                estimatedValue: 67308.00,
                advisorRecommendation: AdvisorRecommendation(
                    advisorName: "Sofia",
                    advisorFullName: "Sofia Patel",
                    advisorTitle: "Financial Advisor",
                    advisorCredentials: nil,
                    advisorCompany: "Schwab",
                    advisorPhone: nil,
                    advisorPhotoAsset: "SofiaPatelAvatar",
                    conversationDate: Date(),
                    conversationDuration: 18,
                    discussionPoints: [],
                    recommendationText: "Let's discuss your options",
                    holdPercentage: 0.60,
                    sellPercentage: 0.40
                ),
                taxEstimate: nil,
                timelineEvents: nil,
                vestHistory: nil
            ),
            onApprove: { print("Approve tapped") },
            onRequestChanges: { print("Request changes tapped") }
        )
    }
    .padding()
}
