import SwiftUI

struct ExecutionSheet: View {
    let recommendation: AdvisorRecommendation
    let vest: VestEvent
    @Environment(\.dismiss) var dismiss

    @State private var executionState: ExecutionState = .confirmation
    @State private var animateIn = false
    @State private var spinnerRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var successRipple: CGFloat = 0

    enum ExecutionState {
        case confirmation
        case executing
        case success
    }

    // Calculated values
    private var holdShares: Int {
        Int(Double(vest.sharesVesting) * recommendation.holdPercentage)
    }

    private var sellShares: Int {
        vest.sharesVesting - holdShares
    }

    private var estimatedHoldValue: Double {
        Double(holdShares) * vest.stockPrice
    }

    private var estimatedSellValue: Double {
        Double(sellShares) * vest.stockPrice
    }

    private var orderNumber: String {
        "SCH-2026-\(String(format: "%06d", Int.random(in: 100000...999999)))"
    }

    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }

    var body: some View {
        ZStack {
            // Background blur
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()

            Group {
                switch executionState {
                case .confirmation:
                    confirmationView
                case .executing:
                    executingView
                case .success:
                    successView
                }
            }
            .opacity(animateIn ? 1 : 0)
            .scaleEffect(animateIn ? 1 : 0.95)
            .blur(radius: animateIn ? 0 : 10)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                animateIn = true
            }
        }
    }

    // MARK: - Confirmation View

    var confirmationView: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Execute Fred's Plan")
                    .font(.title2.bold())

                Text("Review your order")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Vest details
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("\(vest.sharesVesting.formatted()) shares")
                        .font(.headline)
                    Spacer()
                    Text("@ $\(vest.stockPrice, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                Text("Est. total: \(vest.estimatedValue, format: .currency(code: "USD"))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Split breakdown
            VStack(spacing: 12) {
                // Hold
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("HOLD")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        Text("\(holdShares.formatted()) shares")
                            .font(.title3.bold())
                            .foregroundStyle(.green)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("ESTIMATE")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text(estimatedHoldValue, format: .currency(code: "USD"))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(Color.green.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Sell
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SELL")
                            .font(.caption.bold())
                            .foregroundStyle(.secondary)
                        Text("\(sellShares.formatted()) shares")
                            .font(.title3.bold())
                            .foregroundStyle(.blue)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("ESTIMATE")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        Text(estimatedSellValue, format: .currency(code: "USD"))
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Disclaimer
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption)
                    Text("Market Order")
                        .font(.caption.bold())
                }
                .foregroundStyle(.orange)

                Text("Final value determined at market execution on \(vest.vestDate, style: .date). Estimates based on current price of $\(vest.stockPrice, specifier: "%.2f").")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(Color.orange.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()

            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    executeOrder()
                }) {
                    Text("Confirm & Execute")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 400)
    }

    // MARK: - Executing View

    var executingView: some View {
        VStack(spacing: 24) {
            // Liquid Glass spinner
            ZStack {
                // Pulsing gradient ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.8),
                                Color.blue.opacity(0.8),
                                Color.green.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 4
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(spinnerRotation))
                    .scaleEffect(pulseScale)
                    .shadow(color: .green.opacity(0.3), radius: 8, y: 0)

                // Inner frosted circle
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 60, height: 60)

                // Icon
                Image(systemName: "bolt.fill")
                    .font(.title)
                    .foregroundStyle(.green)
            }
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    spinnerRotation = 360
                }
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    pulseScale = 1.15
                }
            }

            Text("Executing order...")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }

    // MARK: - Success View

    var successView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Success checkmark with ripple
            ZStack {
                // Expanding gradient ripple
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.6),
                                Color.green.opacity(0)
                            ],
                            startPoint: .center,
                            endPoint: .bottom
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 100 * successRipple, height: 100 * successRipple)
                    .opacity(1.0 - successRipple)

                // Checkmark circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .green.opacity(0.4), radius: 12, y: 4)

                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    successRipple = 1.5
                }
            }

            VStack(spacing: 8) {
                Text("Order Submitted")
                    .font(.title2.bold())

                Text("Order #: \(orderNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Submitted: \(currentTime)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            // Details
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                    Text("Executes on \(vest.vestDate, style: .date)")
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

                Divider()

                HStack {
                    Text("Hold:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(holdShares.formatted()) shares")
                        .font(.subheadline.bold())
                }

                HStack {
                    Text("Sell:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(sellShares.formatted()) shares")
                        .font(.subheadline.bold())
                }
            }
            .padding(16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()

            // Close button
            Button(action: {
                dismiss()
            }) {
                Text("Close")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(24)
        .frame(maxWidth: 400)
    }

    // MARK: - Actions

    private func executeOrder() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            executionState = .executing
        }

        // Simulate 2 second execution
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                executionState = .success
            }
        }
    }
}

#Preview {
    Text("Background")
        .sheet(isPresented: .constant(true)) {
            ExecutionSheet(
                recommendation: AdvisorRecommendation(
                    advisorName: "Fred",
                    advisorFullName: "Fred Amsden",
                    advisorTitle: "Senior Wealth Advisor",
                    advisorCredentials: "CFP®",
                    advisorCompany: "Schwab Private Client",
                    advisorPhone: "(650) 555-1212",
                    conversationDate: Date(),
                    conversationDuration: 22,
                    discussionPoints: [
                        "Tax-loss harvesting opportunities",
                        "Donor-advised fund contribution strategy"
                    ],
                    recommendationText: "Execute the 70/30 split on vest date.",
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
                    timelineEvents: nil
                )
            )
        }
}
