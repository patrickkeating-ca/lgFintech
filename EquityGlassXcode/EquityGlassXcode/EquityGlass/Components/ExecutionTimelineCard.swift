import SwiftUI

struct ExecutionTimelineCard: View {
    let vest: VestEvent
    @State private var isExpanded = false

    // Execution timeline milestones (4 specific dates)
    var executionMilestones: [(date: Date, title: String, description: String, icon: String, color: Color)] {
        let calendar = Calendar.current
        let vestDate = vest.vestDate

        // Calculate dates based on vest date
        let modifyDeadline = calendar.date(byAdding: .day, value: 7, to: vestDate) ?? vestDate
        let blackoutStart = calendar.date(byAdding: .day, value: 11, to: vestDate) ?? vestDate
        let executionDate = calendar.date(byAdding: .day, value: 21, to: vestDate) ?? vestDate

        // Calculate shares to sell (30% of total)
        let sellShares = vest.sellShares

        return [
            (
                date: vestDate,
                title: "Vest Date",
                description: "\(vest.sharesVesting.formatted()) shares vest. Held in brokerage account.",
                icon: "calendar.badge.clock",
                color: .blue
            ),
            (
                date: modifyDeadline,
                title: "Modify/Cancel Deadline",
                description: "Last day to change or cancel plan.",
                icon: "exclamationmark.circle",
                color: .orange
            ),
            (
                date: blackoutStart,
                title: "Blackout Period",
                description: "Trading restricted (earnings/announcement)",
                icon: "lock.circle",
                color: .red
            ),
            (
                date: executionDate,
                title: "Execution Date",
                description: "\(sellShares.formatted()) shares sold. Funds available same day.",
                icon: "checkmark.circle",
                color: .green
            )
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("EXECUTION TIMELINE")
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

            if !isExpanded {
                // Collapsed state - show summary
                Text("4 key dates • Tap to expand")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                // Expanded state - show all 4 milestones
                VStack(spacing: 16) {
                    ForEach(Array(executionMilestones.enumerated()), id: \.offset) { index, milestone in
                        timelineRow(
                            date: milestone.date,
                            title: milestone.title,
                            description: milestone.description,
                            icon: milestone.icon,
                            color: milestone.color,
                            isLast: index == executionMilestones.count - 1
                        )
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
        .accessibilityLabel("Execution timeline. 4 key dates. \(isExpanded ? "Expanded" : "Tap to expand")")
        .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand timeline")
    }

    @ViewBuilder
    func timelineRow(date: Date, title: String, description: String, icon: String, color: Color, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)

                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.bold())
                    .foregroundStyle(.primary)

                Text(date, format: .dateTime.month(.abbreviated).day().year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(.bottom, isLast ? 0 : 8)
    }
}

#Preview {
    ExecutionTimelineCard(
        vest: VestEvent(
            id: UUID(),
            vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
            companyName: "Steamboat Co",
            sharesVesting: 3430,
            ticker: "STBT",
            stockPrice: 112.18,
            stockPriceLastUpdated: Date(),
            estimatedValue: 384777.40,
            advisorRecommendation: nil,
            taxEstimate: nil,
            timelineEvents: [
                TimelineEvent(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
                    type: .vest,
                    title: "RSU Vest: 3,430 shares",
                    description: "Shares vest and are held in brokerage account",
                    actionable: true
                ),
                TimelineEvent(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: 54, to: Date())!,
                    type: .cancelPeriod,
                    title: "Modify/Cancel Deadline",
                    description: "Last day to change or cancel plan",
                    actionable: true
                ),
                TimelineEvent(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: 58, to: Date())!,
                    type: .blackoutPeriod,
                    title: "Blackout Period Begins",
                    description: "Trading restricted (earnings announcement)",
                    actionable: false
                ),
                TimelineEvent(
                    id: UUID(),
                    date: Calendar.current.date(byAdding: .day, value: 68, to: Date())!,
                    type: .vest,
                    title: "Execution Date",
                    description: "1,029 shares sold. Funds available same day.",
                    actionable: true
                )
            ],
            vestHistory: nil
        )
    )
    .padding()
}
