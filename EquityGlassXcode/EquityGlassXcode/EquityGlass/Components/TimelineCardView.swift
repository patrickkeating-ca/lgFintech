import SwiftUI

struct TimelineCardView: View {
    let event: TimelineEvent

    private var iconColor: Color {
        // Match equity type badge colors (Blue/Purple/Orange)
        switch event.type {
        case .vest: return .blue // RSU
        case .esppPurchase: return .purple // ESPP
        case .performanceReview: return .orange // PSU (performance-related)
        default:
            // Fallback to original color mapping for other event types
            switch event.type.color {
            case "blue": return .blue
            case "green": return .green
            case "orange": return .orange
            case "red": return .red
            case "purple": return .purple
            case "yellow": return .yellow
            case "gray": return .gray
            case "cyan": return .cyan
            default: return .blue
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                // Header with icon and days until
                HStack(alignment: .top) {
                    Image(systemName: event.type.icon)
                        .font(.title2)
                        .foregroundStyle(iconColor)
                        .frame(width: 40, height: 40)
                        .background(iconColor.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    Spacer()

                    if !event.isPast {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("\(event.daysUntil)")
                                .font(.title.bold())
                                .foregroundStyle(iconColor)
                            Text(event.daysUntil == 1 ? "day" : "days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        Text("Past")
                            .font(.caption.bold())
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.regularMaterial)
                            .clipShape(Capsule())
                    }
                }

                // Title and description
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        // NEW badge inline with title
                        if shouldShowNewBadge {
                            Text("NEW")
                                .font(.caption2.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.blue)
                                .clipShape(Capsule())
                                .shadow(color: .blue.opacity(0.3), radius: 4, y: 2)
                        }

                        Text(event.title)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                    }

                    Text(event.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                // Date
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(event.date, style: .date)
                        .font(.caption)
                }
                .foregroundStyle(.tertiary)

                // Action indicators
                if event.actionable && !event.isPast {
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "hand.tap")
                                .font(.caption)
                            Text("Action Required")
                                .font(.caption.bold())
                        }
                        .foregroundStyle(iconColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(iconColor.opacity(0.1))
                        .clipShape(Capsule())

                        // Calendar badge (visual only for demo)
                        HStack(spacing: 4) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.caption2)
                            Text("Add")
                                .font(.caption2.bold())
                        }
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.blue.opacity(0.1))
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    }
                }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.primary.opacity(0.1), radius: 10, y: 5)
    }

    // Show NEW badge for vests, ESPP purchases, and grants/awards
    private var shouldShowNewBadge: Bool {
        (event.type == .vest || event.type == .esppPurchase || event.type == .performanceReview) && !event.isPast
    }
}

#Preview {
    TimelineCardView(event: TimelineEvent(
        id: UUID(),
        date: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
        type: .vest,
        title: "RSU Vest: 3,430 shares",
        description: "Execute 70/30 split per Fred's recommendation. Coordinate with Maria for DAF transfer.",
        actionable: true
    ))
    .padding()
}
