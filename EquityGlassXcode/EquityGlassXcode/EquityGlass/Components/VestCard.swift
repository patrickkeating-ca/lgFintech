import SwiftUI

struct VestCard: View {
    let vest: VestEvent
    @State private var isPressed = false
    @State private var shimmerProgress: CGFloat = -1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            Text("UPCOMING VEST")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Company name and stock price
            HStack(alignment: .top) {
                Text(vest.companyName)
                    .font(.title2.bold())
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(vest.ticker): \(vest.stockPrice, format: .currency(code: "USD"))")
                        .font(.headline)
                    Text("Updated \(vest.stockPriceLastUpdated.formatted(date: .omitted, time: .shortened))")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            // Vest date and countdown
            HStack {
                Text(vest.vestDate, style: .date)
                    .font(.subheadline)
                Text("•")
                    .foregroundStyle(.secondary)
                Text("\(vest.daysUntilVest) days")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Divider()
                .padding(.vertical, 4)

            // Share count (always visible)
            Text("\(vest.sharesVesting.formatted()) shares")
                .font(.headline)

            // Dollar amount (always visible)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(vest.estimatedValue, format: .currency(code: "USD"))")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .contentTransition(.numericText(value: vest.estimatedValue))
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Disclaimer
                Text("Amount may change based on stock price")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }


        }
        .padding(20)
        .background(.ultraThinMaterial)
        .overlay(
            // Shimmer effect
            GeometryReader { geo in
                let gradient = LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.4),
                        .clear
                    ],
                    startPoint: .init(x: shimmerProgress - 0.5, y: 0.5),
                    endPoint: .init(x: shimmerProgress, y: 0.5)
                )

                if isPressed {
                    Rectangle()
                        .fill(gradient)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .onAppear {
                            withAnimation(.linear(duration: 0.8)) {
                                shimmerProgress = 1.5
                            }
                        }
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        shimmerProgress = -0.5
                    }
                }
                .onEnded { _ in
                    isPressed = false
                    shimmerProgress = -0.5
                }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Vest amount: \(vest.estimatedValue.formatted(.currency(code: "USD")))")
        .accessibilityHint("")
    }
}

#Preview {
    VestCard(vest: VestEvent(
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
        timelineEvents: nil
    ))
    .padding()
}
