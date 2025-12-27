import SwiftUI

struct VestCard: View {
    let vest: VestEvent
    let onTap: () -> Void
    @State private var isPressed = false
    @State private var shimmerProgress: CGFloat = -1.0

    var body: some View {
        // Option 5: Contextual gradient backdrop
        ZStack {
            // Subtle radial gradient spotlight effect
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.03),
                    Color.purple.opacity(0.02),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 200
            )

            VStack(alignment: .leading, spacing: 16) {
                // Header
                Text("UPCOMING VEST")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // Share count (prominent, centered)
                Text("\(vest.sharesVesting.formatted()) shares")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .center)

                // Vest date with countdown
                HStack(alignment: .top) {
                    Text("Vest Date")
                        .font(.subheadline)
                        .foregroundStyle(.primary)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(vest.vestDate, format: .dateTime.month(.abbreviated).day().year())
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("(\(vest.daysUntilVest) days)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                // Tap hint
                Text("Tap for estimated value & tax")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .overlay(
                // Option 1: Faint white gradient overlay for depth
                LinearGradient(
                    colors: [
                        .white.opacity(0.08),
                        .white.opacity(0.02),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                // Shimmer effect on press
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
            .overlay(
                // Option 3: Premium border treatment with gradient
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.3),
                                .white.opacity(0.1),
                                .clear,
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            // Option 1: Enhanced shadow for elevated depth
            .shadow(color: Color.primary.opacity(0.08), radius: 8, y: 4)
            .shadow(color: Color.primary.opacity(0.12), radius: 16, y: 8)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPressed)
        }
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
                    onTap()
                }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Vest amount: \(vest.estimatedValue.formatted(.currency(code: "USD")))")
        .accessibilityHint("Double tap for estimated value and tax breakdown")
    }
}

#Preview {
    VestCard(
        vest: VestEvent(
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
        ),
        onTap: { print("Tapped vest card") }
    )
    .padding()
}
