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
        HStack(spacing: 0) {
            // Hold section (70%)
            VStack {
                Text("70%")
                    .font(.title2.bold())
                    .foregroundStyle(.green)
                Text("HOLD")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(.thinMaterial.opacity(0.8))
            .background(Color.green.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Divider
            Rectangle()
                .fill(Color.secondary.opacity(0.5))
                .frame(width: 1)
                .padding(.vertical, 8)

            // Sell section (30%)
            VStack {
                Text("30%")
                    .font(.title2.bold())
                    .foregroundStyle(.orange)
                Text("SELL")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(.thinMaterial.opacity(0.8))
            .background(Color.orange.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    var expandedView: some View {
        HStack(spacing: 12) {
            // Hold section (70%)
            VStack(alignment: .leading, spacing: 12) {
                Text("HOLD 70%")
                    .font(.title3.bold())
                    .foregroundStyle(.green)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(vest.holdShares) sh")
                        .font(.title2.monospacedDigit())

                    Text(vest.holdValue, format: .currency(code: "USD"))
                        .font(.title3.bold())
                }

                Spacer()

                Text("Move to portfolio")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(.regularMaterial)
            .background(Color.green.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Sell section (30%)
            VStack(alignment: .leading, spacing: 12) {
                Text("SELL 30%")
                    .font(.title3.bold())
                    .foregroundStyle(.orange)

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(vest.sellShares) sh")
                        .font(.title2.monospacedDigit())

                    Text(vest.sellValue, format: .currency(code: "USD"))
                        .font(.title3.bold())
                }

                Spacer()

                Text("Transfer to checking")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(.regularMaterial)
            .background(Color.orange.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(height: 220)
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
            companyName: "Steamboat Co.",
            sharesVesting: 2500,
            estimatedValue: 127450.00,
            advisorRecommendation: AdvisorRecommendation(
                advisorName: "Fred",
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
            taxEstimate: nil
        ),
        onShowConversation: { print("Show conversation") }
    )
    .padding()
}
