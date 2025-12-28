import SwiftUI

struct ViewTradeOrderSheet: View {
    let vest: VestEvent
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Review Trade Plan")
                        .font(.title2.bold())
                        .padding(.top, 8)

                    // Execution details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(vest.sharesVesting.formatted()) shares (RSU)")
                            .font(.headline)

                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                            Text("Executes on \(executionDate, style: .date)")
                                .font(.subheadline)
                            Spacer()
                        }

                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(.blue)
                            Text("Market open")
                                .font(.subheadline)
                            Spacer()
                        }
                    }
                    .padding(16)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    // Split breakdown
                    VStack(spacing: 12) {
                        // Hold
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("HOLD")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(vest.holdShares.formatted()) shares")
                                    .font(.title3.bold())
                                    .foregroundStyle(.green)
                            }

                            HStack(spacing: 6) {
                                Image(systemName: "arrow.right")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                Text("Schwab Brokerage ...328")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(16)
                        .background(Color.green.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        // Sell
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("SELL")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(vest.sellShares.formatted()) shares")
                                    .font(.title3.bold())
                                    .foregroundStyle(.blue)
                            }

                            HStack(spacing: 6) {
                                Image(systemName: "arrow.right")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                Text("Checking Acct ...582")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(16)
                        .background(Color.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Spacer(minLength: 20)

                    // Order details
                    VStack(spacing: 4) {
                        Text("Order #: \(orderNumber)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Submitted: \(submittedTimestamp)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(24)
                .padding(.bottom, 40)
            }
            .navigationTitle("Trade Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Helper Properties

    private var orderNumber: String {
        "SCH-2026-\(String(format: "%06d", Int.random(in: 100000...999999)))"
    }

    private var submittedTimestamp: String {
        let now = Date()
        let calendar = Calendar.current

        if calendar.isDateInToday(now) {
            // Today: show time only
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Today at \(formatter.string(from: now))"
        } else if calendar.isDateInYesterday(now) {
            // Yesterday
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Yesterday at \(formatter.string(from: now))"
        } else {
            // Other days: show full date and time
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: now)
        }
    }

    // Execution date is 21 days after vest date (matches ExecutionTimelineCard)
    private var executionDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: 21, to: vest.vestDate) ?? vest.vestDate
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            ViewTradeOrderSheet(
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
        }
}
