import SwiftUI

struct TradeRecommendationCard: View {
    let vest: VestEvent
    @State private var isExpanded = false

    var body: some View {
        // Liquid Glass backdrop
        ZStack {
            // Subtle radial gradient spotlight effect
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.03),
                    Color.purple.opacity(0.02),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 200
            )

            VStack(alignment: .leading, spacing: 16) {
                // Header
                Text("TRADE PLAN RECOMMENDATION")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .tracking(0.5)

                // Split display (side-by-side, centered content)
                HStack(spacing: 12) {
                    // Hold section
                    VStack(spacing: 8) {
                        Text("Hold")
                            .font(.subheadline)
                            .foregroundStyle(.primary)

                        Text("\(vest.holdShares.formatted())")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("shares")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Text("Portfolio")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Sell section
                    VStack(spacing: 8) {
                        Text("Sell")
                            .font(.subheadline)
                            .foregroundStyle(.primary)

                        Text("\(vest.sellShares.formatted())")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("shares")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            Text("Checking account")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 12)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(Color.secondary.opacity(0.15), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Why this recommendation (expandable)
                if let recommendation = vest.advisorRecommendation {
                    VStack(alignment: .leading, spacing: 12) {
                        // Toggle button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isExpanded.toggle()
                            }
                        }) {
                            HStack {
                                Text("Why this recommendation")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        // Expanded content
                        if isExpanded {
                            VStack(alignment: .leading, spacing: 12) {
                                Divider()

                                // Recommendation text
                                Text(recommendation.recommendationText)
                                    .font(.body)
                                    .foregroundStyle(.primary)

                                // Discussion points
                                if !recommendation.discussionPoints.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(recommendation.discussionPoints, id: \.self) { point in
                                            HStack(alignment: .top, spacing: 8) {
                                                Text("•")
                                                    .font(.body)
                                                    .foregroundStyle(.secondary)
                                                Text(point)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .overlay(
                // Faint white gradient overlay for depth
                LinearGradient(
                    colors: [
                        .white.opacity(0.08),
                        .white.opacity(0.02),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)
            )
            .overlay(
                // Premium border treatment with gradient
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.3),
                                .white.opacity(0.1),
                                .clear,
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .allowsHitTesting(false)
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            // Enhanced shadow for elevated depth
            .shadow(color: Color.primary.opacity(0.08), radius: 8, y: 4)
            .shadow(color: Color.primary.opacity(0.12), radius: 16, y: 8)
        }
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
                discussionPoints: [
                    "Tax withholding strategy and timing",
                    "Charitable giving coordination for Q1",
                    "Diversification and concentration risk management",
                    "70/30 split balances tax efficiency and long-term growth"
                ],
                recommendationText: "Hold 70% for diversified portfolio, sell 30% for tax withholding and charitable giving",
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
