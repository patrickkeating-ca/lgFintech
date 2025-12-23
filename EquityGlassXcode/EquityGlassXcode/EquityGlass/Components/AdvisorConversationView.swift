import SwiftUI

struct AdvisorConversationView: View {
    let recommendation: AdvisorRecommendation
    @Environment(\.dismiss) var dismiss
    @State private var animateIn = false

    var body: some View {
        VStack(spacing: 0) {
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.title2)
                            .foregroundStyle(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Call with \(recommendation.advisorName)")
                                .font(.headline)

                            HStack(spacing: 4) {
                                Text(recommendation.conversationDate, style: .date)
                                Text("•")
                                Text(recommendation.formattedDuration)
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.bottom, 8)

                    Divider()

                    // Discussion points
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DISCUSSED:")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(recommendation.discussionPoints, id: \.self) { point in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundStyle(.blue)
                                    Text(point)
                                        .font(.body)
                                }
                            }
                        }
                    }

                    Divider()

                    // Recommendation
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(recommendation.advisorName.uppercased())'S RECOMMENDATION:")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)

                        Text(recommendation.recommendationText)
                            .font(.body)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.green.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(20)
            }

            // Fixed action buttons at bottom
            VStack(spacing: 12) {
                Button(action: {
                    // TODO: Deep link to Schwab messaging
                    print("Message \(recommendation.advisorName)")
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Message \(recommendation.advisorName)")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(20)
            .background(.ultraThinMaterial)
        }
        .opacity(animateIn ? 1 : 0)
        .scaleEffect(animateIn ? 1 : 0.95)
        .blur(radius: animateIn ? 0 : 10)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
        .presentationDetents([.medium])
        .presentationBackground(.ultraThinMaterial)
        .presentationBackgroundInteraction(.enabled)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityText)
    }

    var accessibilityText: String {
        let points = recommendation.discussionPoints.joined(separator: ", ")
        return "Call with \(recommendation.advisorName) on \(recommendation.formattedDate), \(recommendation.formattedDuration). Discussed: \(points). \(recommendation.advisorName)'s recommendation: \(recommendation.recommendationText)"
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            AdvisorConversationView(recommendation: AdvisorRecommendation(
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
            ))
        }
}
