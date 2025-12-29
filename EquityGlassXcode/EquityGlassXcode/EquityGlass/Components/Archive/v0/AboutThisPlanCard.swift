import SwiftUI

struct AboutThisPlanCard: View {
    let recommendation: AdvisorRecommendation
    let onTapAttribution: () -> Void
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("ABOUT THIS PLAN")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .tracking(0.5)

                Spacer()

                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.spring(response: 0.3), value: isExpanded)
            }

            // Conversation metadata (tappable for modal)
            Button(action: onTapAttribution) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text("Conversation with")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                        Text(recommendation.fullCredentials)
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                    }

                    HStack(spacing: 4) {
                        Text(recommendation.conversationDate, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("•")
                            .foregroundStyle(.tertiary)
                        Text("\(recommendation.conversationDuration) min")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)

            // Plan overview (one-liner)
            Text(recommendation.recommendationText)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(isExpanded ? nil : 2)

            // Expand hint (when collapsed)
            if !isExpanded {
                Text("Tap for notes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Discussion notes (expandable)
            if isExpanded {
                Divider()
                    .padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("DISCUSSION NOTES")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    ForEach(Array(recommendation.discussionPoints.enumerated()), id: \.offset) { index, point in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .foregroundStyle(.secondary)
                            Text(point)
                                .font(.subheadline)
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.primary.opacity(0.05), radius: 4, y: 2)
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                isExpanded.toggle()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("About this plan. Conversation with \(recommendation.fullCredentials) on \(recommendation.formattedDate), \(recommendation.conversationDuration) minutes. \(recommendation.recommendationText). \(isExpanded ? "Expanded" : "Tap to expand")")
        .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand discussion notes")
    }
}

#Preview {
    AboutThisPlanCard(
        recommendation: AdvisorRecommendation(
            advisorName: "Fred",
            advisorFullName: "Fred Amsden",
            advisorTitle: "Senior Wealth Advisor",
            advisorCredentials: "CFP®",
            advisorCompany: "Schwab Private Client",
            advisorPhone: "(650) 555-1212",
            advisorPhotoAsset: "AdvisorAvatar",
            conversationDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
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
        onTapAttribution: { print("Open conversation modal") }
    )
    .padding()
}
