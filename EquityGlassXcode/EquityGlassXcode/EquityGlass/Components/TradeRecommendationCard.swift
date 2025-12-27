import SwiftUI

struct TradeRecommendationCard: View {
    let vest: VestEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("TRADE PLAN RECOMMENDATION")
                .font(.caption)
                .foregroundStyle(.secondary)
                .tracking(0.5)

            // Split display (side-by-side)
            HStack(spacing: 12) {
                // Hold section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hold")
                        .font(.body.bold())
                        .foregroundStyle(.primary)

                    Text("\(vest.holdShares.formatted()) shares")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Text("Portfolio")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Sell section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sell")
                        .font(.body.bold())
                        .foregroundStyle(.primary)

                    Text("\(vest.sellShares.formatted()) shares")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Text("Checking account")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.green.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.primary.opacity(0.05), radius: 4, y: 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Trade plan recommendation. Hold \(vest.holdShares) shares to portfolio. Sell \(vest.sellShares) shares to checking account.")
    }
}

#Preview {
    TradeRecommendationCard(
        vest: VestEvent(
            id: UUID(),
            vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
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
        )
    )
    .padding()
}
