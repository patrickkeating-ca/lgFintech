import SwiftUI

struct SplitVisualization: View {
    let vest: VestEvent
    let onShowConversation: () -> Void
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("ADVISOR RECOMMENDATION")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Split card (tappable for expand/collapse)
            Group {
                if !isExpanded {
                    compactView
                } else {
                    expandedView
                }
            }
            .onTapGesture {
                toggleExpansion()
            }

            // Attribution (tappable for modal)
            if let recommendation = vest.advisorRecommendation {
                VStack(alignment: .leading, spacing: 4) {
                    Text("From your call with \(recommendation.advisorName)")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                        .underline()
                    Text(recommendation.conversationDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 4)
                .onTapGesture {
                    onShowConversation()
                }
            }

            // Hint text
            if !isExpanded {
                Text("Tap card for breakdown")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("Tap attribution to view conversation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
        .accessibilityHint("Double tap for detailed breakdown")
    }

    var compactView: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Hold section (70%)
                VStack {
                    Text("\(Int((vest.advisorRecommendation?.holdPercentage ?? 0.7) * 100))%")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    Text("HOLD")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(width: geometry.size.width * (vest.advisorRecommendation?.holdPercentage ?? 0.7))
                .frame(height: 120)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Divider
                Rectangle()
                    .fill(Color.secondary.opacity(0.5))
                    .frame(width: 1)
                    .padding(.vertical, 8)

                // Sell section (30%)
                VStack {
                    Text("\(Int((vest.advisorRecommendation?.sellPercentage ?? 0.3) * 100))%")
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    Text("SELL")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(width: geometry.size.width * (vest.advisorRecommendation?.sellPercentage ?? 0.3))
                .frame(height: 120)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(height: 120)
    }

    var expandedView: some View {
        VStack(spacing: 12) {
            // Hold section
            VStack(alignment: .leading, spacing: 8) {
                Text("HOLD \(Int((vest.advisorRecommendation?.holdPercentage ?? 0.7) * 100))%")
                    .font(.title3.bold())

                HStack(alignment: .bottom, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(vest.holdShares) shares")
                            .font(.title.monospacedDigit())
                        Text(vest.holdValue, format: .currency(code: "USD"))
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Move to portfolio")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(isExpanded ? 0.2 : 0), radius: 10, y: 5)

            // Sell section
            VStack(alignment: .leading, spacing: 8) {
                Text("SELL \(Int((vest.advisorRecommendation?.sellPercentage ?? 0.3) * 100))%")
                    .font(.title3.bold())

                HStack(alignment: .bottom, spacing: 16) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(vest.sellShares) shares")
                            .font(.title.monospacedDigit())
                        Text(vest.sellValue, format: .currency(code: "USD"))
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("Transfer to checking")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(isExpanded ? 0.2 : 0), radius: 10, y: 5)
        }
        .frame(height: 280)
    }

    func toggleExpansion() {
        let generator = UIImpactFeedbackGenerator(style: isExpanded ? .light : .medium)
        generator.impactOccurred()

        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            isExpanded.toggle()
        }
    }

    var accessibilityText: String {
        guard let rec = vest.advisorRecommendation else {
            return "No advisor recommendation"
        }

        let holdValueText = vest.holdValue.formatted(.currency(code: "USD"))
        let sellValueText = vest.sellValue.formatted(.currency(code: "USD"))

        if isExpanded {
            return "Hold section: \(vest.holdShares) shares, \(holdValueText), move to portfolio. Sell section: \(vest.sellShares) shares, \(sellValueText), transfer to checking."
        } else {
            return "Advisor recommendation: Hold \(Int(rec.holdPercentage * 100))%, Sell \(Int(rec.sellPercentage * 100))%. From your call with \(rec.advisorName) on \(rec.formattedDate)."
        }
    }
}

#Preview {
    SplitVisualization(
        vest: VestEvent(
            id: UUID(),
            vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
            companyName: "Minnievision",
            sharesVesting: 3430,
            ticker: "MNVSZA",
            stockPrice: 168.73,
            stockPriceLastUpdated: Date(),
            estimatedValue: 578963.9,
            advisorRecommendation: AdvisorRecommendation(
                advisorName: "Fred",
                advisorFullName: "Fred Amsden",
                advisorTitle: "Senior Wealth Advisor",
                advisorCredentials: "CFP®",
                advisorCompany: "Schwab Private Client",
                advisorPhone: nil,
                conversationDate: Date(),
                conversationDuration: 22,
                discussionPoints: [
                    "Tax implications of holding vs selling",
                    "Your goal: diversify from company stock",
                    "Market outlook for Q1",
                    "70/30 split strategy"
                ],
                recommendationText: "Hold 70% in diversified portfolio, sell 30% to cover taxes + cash needs",
                holdPercentage: 0.70,
                sellPercentage: 0.30
            ),
            taxEstimate: nil,
            timelineEvents: nil,
            vestHistory: nil
        ),
        onShowConversation: { print("Show conversation") }
    )
    .padding()
}
