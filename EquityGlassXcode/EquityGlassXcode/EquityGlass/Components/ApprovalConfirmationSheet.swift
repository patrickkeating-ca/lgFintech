import SwiftUI

struct ApprovalConfirmationSheet: View {
    let vest: VestEvent
    let onConfirm: () -> Void
    @Environment(\.dismiss) var dismiss
    @State private var agreedToTerms = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Title
                Text("Confirm Authorization")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)

                // Trade plan recommendation
                VStack(alignment: .leading, spacing: 16) {
                    Text("TRADE PLAN RECOMMENDATION")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Hold")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(vest.holdShares.formatted()) shares → Portfolio")
                                .font(.body.bold())
                                .foregroundStyle(.primary)
                        }

                        HStack {
                            Text("Sell")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(vest.sellShares.formatted()) shares → Checking")
                                .font(.body.bold())
                                .foregroundStyle(.primary)
                        }

                        HStack {
                            Text("Execution Date")
                                .font(.body)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(executionDate, format: .dateTime.month(.abbreviated).day().year())
                                .font(.body.bold())
                                .foregroundStyle(.primary)
                        }
                    }
                }

                // What happens next
                VStack(alignment: .leading, spacing: 12) {
                    Text("WHAT HAPPENS NEXT")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    Text(whatHappensNextText)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Your control
                VStack(alignment: .leading, spacing: 16) {
                    Text("YOUR CONTROL")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .tracking(0.5)

                    // Change plan
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.pencil")
                                .font(.body)
                                .foregroundStyle(.green)

                            Text("CHANGE PLAN")
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)
                        }

                        Text("Request changes anytime until \(modifyDeadline)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Cancel plan
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle")
                                .font(.body)
                                .foregroundStyle(.red)

                            Text("CANCEL PLAN")
                                .font(.subheadline.bold())
                                .foregroundStyle(.primary)
                        }

                        Text("Cancel anytime until \(modifyDeadline)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("If cancelled: All \(vest.sharesVesting.formatted()) shares will be held in your brokerage account (100% hold).")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 4)
                    }
                }

                Spacer(minLength: 20)

                // Terms
                Text("By confirming, you agree to Schwab's **Terms & Conditions** and authorize this transaction.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                // Action buttons
                VStack(spacing: 12) {
                    // Confirm button
                    Button(action: {
                        onConfirm()
                        dismiss()
                    }) {
                        Text("Confirm Authorization")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Go back button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Go Back")
                            .font(.body)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.15))
                            .foregroundStyle(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(20)
        }
        .background(.ultraThinMaterial)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    var executionDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 21, to: vest.vestDate) ?? vest.vestDate
    }

    var modifyDeadline: String {
        let calendar = Calendar.current
        let deadline = calendar.date(byAdding: .day, value: 7, to: vest.vestDate) ?? vest.vestDate
        return deadline.formatted(.dateTime.month(.abbreviated).day().year())
    }

    var whatHappensNextText: String {
        let advisorName = vest.advisorRecommendation?.displayName ?? "Your advisor"
        let execDate = executionDate.formatted(.dateTime.month(.abbreviated).day().year())
        return "\(advisorName) will execute this plan on your behalf on \(execDate). By authorizing, you are putting this plan in motion."
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            ApprovalConfirmationSheet(
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
                ),
                onConfirm: { print("Plan approved!") }
            )
        }
}
