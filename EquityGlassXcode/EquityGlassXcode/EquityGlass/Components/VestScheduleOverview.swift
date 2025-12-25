import SwiftUI

struct VestScheduleOverview: View {
    let currentVest: VestEvent
    @State private var isExpanded = false

    // Mock upcoming vests for demo
    private var upcomingVests: [(date: String, type: String, shares: Int, isCurrent: Bool)] {
        [
            (date: "Feb 6, 2026", type: "RSU", shares: currentVest.sharesVesting, isCurrent: true),
            (date: "May 15, 2026", type: "RSU", shares: Int(Double(currentVest.sharesVesting) * 0.95), isCurrent: false),
            (date: "Aug 15, 2026", type: "PSU", shares: Int(Double(currentVest.sharesVesting) * 1.10), isCurrent: false)
        ]
    }

    private func typeColor(_ type: String) -> Color {
        switch type {
        case "RSU": return .blue
        case "PSU": return .purple
        case "ESPP": return .green
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header - always visible
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                        .font(.subheadline)

                    Text("3 vests scheduled in 2026")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            // Expanded vest list
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(Array(upcomingVests.enumerated()), id: \.offset) { index, vest in
                        HStack(spacing: 12) {
                            // Caret for current vest
                            Image(systemName: vest.isCurrent ? "chevron.right.circle.fill" : "circle")
                                .font(.caption)
                                .foregroundStyle(vest.isCurrent ? .blue : .gray)
                                .frame(width: 20)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(vest.date)
                                    .font(vest.isCurrent ? .subheadline.bold() : .subheadline)
                                    .foregroundStyle(vest.isCurrent ? .primary : .secondary)

                                HStack(spacing: 6) {
                                    // Liquid Glass type badge
                                    Text(vest.type)
                                        .font(.caption2.bold())
                                        .foregroundStyle(typeColor(vest.type))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(typeColor(vest.type).opacity(0.15))
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())

                                    Text("\(vest.shares.formatted()) shares")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(vest.isCurrent ? Color.blue.opacity(0.12) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 4)
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    VestScheduleOverview(currentVest: VestEvent(
        id: UUID(),
        vestDate: Calendar.current.date(byAdding: .day, value: 47, to: Date())!,
        companyName: "Minnievision",
        sharesVesting: 3430,
        ticker: "MNVSZA",
        stockPrice: 168.73,
        stockPriceLastUpdated: Date(),
        estimatedValue: 578963.9,
        advisorRecommendation: nil,
        taxEstimate: nil,
        timelineEvents: nil,
        vestHistory: nil
    ))
    .padding()
}
