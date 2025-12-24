import SwiftUI

struct AdvisorHeroCard: View {
    let recommendation: AdvisorRecommendation
    let onTap: () -> Void
    @State private var isPulsing = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                // Avatar and credentials
                HStack(spacing: 12) {
                    // Avatar placeholder (ready for photo)
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Text(recommendation.advisorName.prefix(1))
                                .font(.title.bold())
                                .foregroundStyle(.white)
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(recommendation.fullCredentials)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        if let title = recommendation.advisorTitle {
                            Text(title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        if let company = recommendation.advisorCompany {
                            Text(company)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Divider()

                // Recommendation summary
                VStack(alignment: .leading, spacing: 8) {
                    Text("RECOMMENDATION")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    HStack(spacing: 12) {
                        // Hold
                        HStack(spacing: 6) {
                            Text("Hold")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(Int(recommendation.holdPercentage * 100))%")
                                .font(.title2.bold())
                                .foregroundStyle(.green)
                        }

                        Text("•")
                            .foregroundStyle(.tertiary)

                        // Sell
                        HStack(spacing: 6) {
                            Text("Sell")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(Int(recommendation.sellPercentage * 100))%")
                                .font(.title2.bold())
                                .foregroundStyle(.blue)
                        }
                    }

                    Text("Tap to view full conversation")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(isPulsing ? 0.4 : 0.2),
                                Color.purple.opacity(isPulsing ? 0.4 : 0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .blue.opacity(0.1), radius: 12, y: 6)
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

#Preview {
    AdvisorHeroCard(
        recommendation: AdvisorRecommendation(
            advisorName: "Fred",
            advisorFullName: "Fred Amsden",
            advisorTitle: "Senior Wealth Advisor",
            advisorCredentials: "CFP®",
            advisorCompany: "Schwab Private Client",
            conversationDate: Date(),
            conversationDuration: 22,
            discussionPoints: ["Test"],
            recommendationText: "Hold 70%, sell 30%",
            holdPercentage: 0.70,
            sellPercentage: 0.30
        ),
        onTap: { print("Tapped") }
    )
    .padding()
}
