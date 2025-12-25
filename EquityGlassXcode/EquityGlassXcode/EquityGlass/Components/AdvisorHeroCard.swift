import SwiftUI

struct AdvisorHeroCard: View {
    let recommendation: AdvisorRecommendation
    let vest: VestEvent
    let onTap: () -> Void
    @State private var isPulsing = false
    @State private var showExecutionSheet = false
    @State private var buttonShimmer: CGFloat = -1.0
    @State private var orderExecuted = false

    var body: some View {
        VStack(spacing: 16) {
            // Tappable advisor section
            Button(action: onTap) {
                HStack(spacing: 12) {
                    Image("AdvisorAvatar")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
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

                        if let phone = recommendation.advisorPhone {
                            Text(phone)
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)

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
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            // Execute/View button
            if !orderExecuted {
                // Execute Plan button with shimmer
                Button(action: {
                    showExecutionSheet = true
                }) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .font(.headline)
                        Text("Execute Plan")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        ZStack {
                            Color.green

                            // Shimmer overlay
                            GeometryReader { geo in
                                let gradient = LinearGradient(
                                    colors: [
                                        .clear,
                                        .white.opacity(0.3),
                                        .clear
                                    ],
                                    startPoint: .init(x: buttonShimmer - 0.3, y: 0.5),
                                    endPoint: .init(x: buttonShimmer, y: 0.5)
                                )

                                Rectangle()
                                    .fill(gradient)
                                    .frame(width: geo.size.width, height: geo.size.height)
                            }
                        }
                    )
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .green.opacity(0.3), radius: 8, y: 4)
                }
                .onAppear {
                    // Trigger shimmer once on appear
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.linear(duration: 1.2)) {
                            buttonShimmer = 1.3
                        }
                    }
                }
            } else {
                // View Trade Order button (after execution)
                Button(action: {
                    showExecutionSheet = true
                }) {
                    HStack {
                        Image(systemName: "doc.text")
                            .font(.headline)
                        Text("View Trade Order")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
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
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
            .sheet(isPresented: $showExecutionSheet) {
                ExecutionSheet(
                    recommendation: recommendation,
                    vest: vest,
                    onOrderExecuted: {
                        orderExecuted = true
                    }
                )
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
            advisorPhone: "(650) 555-1212",
            conversationDate: Date(),
            conversationDuration: 22,
            discussionPoints: ["Test"],
            recommendationText: "Hold 70%, sell 30%",
            holdPercentage: 0.70,
            sellPercentage: 0.30
        ),
        vest: VestEvent(
            id: UUID(),
            vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
            companyName: "Steamboat Co",
            sharesVesting: 3430,
            ticker: "STEAMBO",
            stockPrice: 112.18,
            stockPriceLastUpdated: Date(),
            estimatedValue: 384777.40,
            advisorRecommendation: nil,
            taxEstimate: nil,
            timelineEvents: nil,
            vestHistory: nil
        ),
        onTap: { print("Tapped") }
    )
    .padding()
}
