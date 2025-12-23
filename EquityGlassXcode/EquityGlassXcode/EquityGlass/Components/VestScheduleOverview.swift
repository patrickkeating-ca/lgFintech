import SwiftUI

struct VestScheduleOverview: View {
    let currentVest: VestEvent
    @State private var isExpanded = false

    // Mock upcoming vests for demo
    private var upcomingVests: [(date: String, amount: String, isCurrent: Bool)] {
        [
            (date: "Feb 6, 2026", amount: currentVest.estimatedValue.formatted(.currency(code: "USD")), isCurrent: true),
            (date: "May 15, 2026", amount: "$" + String(Int(currentVest.estimatedValue * 0.95) / 1000) + "K", isCurrent: false),
            (date: "Aug 15, 2026", amount: "$" + String(Int(currentVest.estimatedValue * 0.98) / 1000) + "K", isCurrent: false)
        ]
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

                            VStack(alignment: .leading, spacing: 2) {
                                Text(vest.date)
                                    .font(vest.isCurrent ? .subheadline.bold() : .subheadline)
                                    .foregroundStyle(vest.isCurrent ? .primary : .secondary)

                                Text("\(currentVest.sharesVesting) shares")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }

                            Spacer()

                            Text(vest.amount)
                                .font(vest.isCurrent ? .callout.bold() : .callout)
                                .foregroundStyle(vest.isCurrent ? .primary : .secondary)
                                .monospacedDigit()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(vest.isCurrent ? Color.blue.opacity(0.08) : Color.clear)
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
        taxEstimate: nil
    ))
    .padding()
}
